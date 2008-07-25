module Spelling
  require 'net/https'
  require 'uri'
  require 'rexml/document'

  ASPELL_WORD_DATA_REGEX = Regexp.new(/\&\s\w+\s\d+\s\d+(.*)$/)
  ASPELL_PATH = "aspell-0.60"

  def check_spelling(spell_check_text, command, lang)
    xml_response_values = Array.new
    spell_check_response = 'echo "#{spell_check_text}" | #{ASPELL_PATH} -a -l #{lang}'
    if (spell_check_response != '')
      spelling_errors = spell_check_response.split("\n").slice(1..-1)
      if (command == 'spell')
        for error in spelling_errors
          error.strip!
          if (match_data = error.match(ASPELL_WORD_DATA_REGEX))
            arr = match_data[0].split(' ')
            xml_response_values << error.split(",")
          end 
        end 
      elsif (command == 'suggest') 
        for error in spelling_errors 
          error.strip! 
          if (match_data = error.match(ASPELL_WORD_DATA_REGEX)) 
              xml_response_values << error.split(",")
          end
        end 
      end 
    end 
    return xml_response_values.join("+") 
  end
   
end 
