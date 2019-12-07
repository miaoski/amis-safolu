require './models/application_record.rb'
require './models/raw_content'

RawContent.find_each do |raw|
  term = raw.term

  contents = eval(raw.value)
  contents.each do |content|
    repetition, definitions = content.split('〕')
    repetition = repetition.gsub(' ', '').sub('〔疊', '').to_i
    if repetition != 0
      puts term.repetition unless term.repetition.nil?
      term.update(repetition: repetition)
    end

    definitions = definitions.sub(/\A①/, '')
                             .gsub(/②|③|④|⑤|⑥|⑦/, '①')
                             .split('①')
    definitions.each do |definition|
      def_contents = definition.split(/(?<=[。！？])/)
      def_contents.each do |def_content|
        def_content.sub!(/\A /, '')
        if def_content.match?(/\A(同|似|參見) ?/)
          def_content.sub!(/\A(同|似|參見) ?/, '')
          def_content.split('、').each do |alternative|
            definition.alternatives.create(content: alternative)
          end
        else

        end
      end
    end
  end
end
