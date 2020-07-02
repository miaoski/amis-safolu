# Using online convert service https://soffice.sheethub.net

Dir.glob('*').each do |filename|
  filename, _ = filename.split(".")
  system("curl -X POST -F \"file=@#{Dir.pwd}/#{filename}.docx\" -F \"output_type=html\" https://soffice.sheethub.net |jq -r .content | base64 -D > #{Dir.pwd}/#{filename}.html")
end
