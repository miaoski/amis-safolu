require './models/application_record.rb'
require './models/raw_content'
require './models/term'
require './models/stem'

RawContent.find_each do |raw|
  key = raw.key
  key.sub!('）', '')
  _term, _stem = key.split('（')
  _term.strip!

  stem = Stem.find_or_create_by(name: _stem) if _stem.present?
  if stem.present?
    term = Term.find_or_create_by(name: _term)
    term.update(stem_id: stem.id)
  else
    term = Term.find_or_create_by(name: _term)
  end

  raw.update(term_id: term.id)
end
