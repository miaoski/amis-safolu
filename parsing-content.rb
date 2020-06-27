require 'pry'

require './models/application_record.rb'
require './models/raw_content'
require './models/stem'
require './models/term'
require './models/definition'
require './models/description'
require './models/example'
require './models/synonym'

# 跑一次大約要 10 分鐘
def process_definition(def_string)
  # puts "\n\n\n.............process_definition.............."
  # puts def_string
  def_contents = def_string.split(/(?<=[。！？])/)

  description_content = def_contents.shift
  description = @definition.descriptions.create(term_id: @definition.term_id, content: description_content)

  def_contents.each do |def_content|
    def_content.strip!

    # puts ".............process_definition.............."
    # puts def_content
    if def_content.match?(/\A同 ?/)
      def_content.sub!(/\A同 ?/, '')
      def_content.split('、').each do |synonym|
        synonym.gsub!(/。|！|？/, '')

        # puts "**********同 synonym**************"
        # puts synonym
        description.synonyms.create(content: synonym, term_type: '同')
      end
    elsif def_content.match?(/\A參見 ?/)
      def_content.sub!(/\A參見 ?/, '')
      def_content.split('、').each do |synonym|
        synonym.gsub!(/。|！|？/, '')

        # puts "**********參見 synonym**************"
        # puts synonym
        description.synonyms.create(content: synonym, term_type: '參見')
      end
    else
      if def_content.match?(/,| |!|\.|\?/)
        # puts "***********範例 example*******************"
        # puts def_content
        description.examples.create(content: def_content)
      else
        # puts "***********其他*******************"
        # puts def_content
        @definition.descriptions.create(term_id: @definition.term_id, content: def_content)
      end
    end
  end
end

RawContent.find_each do |raw|
  @term = raw.term
  # puts "\n\n\n=============#{term.name}====================="

  contents = eval(raw.value)
  contents.each do |content|
    if content.scan(/〔疊\d〕/) != []
      _, repetition, definitions = content.split(/〔疊(\d)〕/)
      repetition = repetition.to_i
      if repetition != 0
        # puts term.repetition unless term.repetition.nil?
        @term.update(repetition: repetition)
      end
    else
      definitions = content
    end

    @definition = @term.definitions.create

    def_array = definitions.sub(/\A①/, '')
                           .gsub(/②|③|④|⑤|⑥|⑦/, '①')
                           .split('①')

    def_array.each do |def_string|
      def_string.split(/（\d）/).each_with_index do |inner_def, index|
        if index != 0
          inner_def = "（#{index}）#{inner_def}"
        end

        process_definition(inner_def)
      end
    end
  end
end
