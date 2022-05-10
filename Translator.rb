require 'net/https'
require 'uri'
require 'cgi'
require 'json'
require 'securerandom'
require_relative 'Translate'
require_relative 'Languages'

def l_list(endpoint,language_path)
  endpoint = endpoint
  language_path = language_path
  language_list = Languages.new(endpoint,language_path)
end

class Translator
  subscription_key = '0d8cbb0636b647fcaca34089f4ca2267'
  region_key = "brazilsouth"
  endpoint = "https://api.cognitive.microsofttranslator.com/"
  translation_path = '/translate?api-version=3.0'
  language_path = '/languages?api-version=3.0'
  from = '&detect?'
  to = 'en'

  translate = Translate.new(subscription_key,region_key,endpoint,translation_path)

  l_list(endpoint,language_path)
  language_file =   Languages.file_list
  language_names = Languages.names
  names_list = Languages.list(language_names)

  initial_menu = 
  "=================Bem-Vindo ao tradutor!================
  Siga os passos abaixo para traduzir seu texto:
  -Selecione o idioma original (padrão: Auto Detectar)
  -Selecione o idioma à traduzir (padrão: Inglês)
  -Digite a palavra ou o texto que deseja traduzir.
  Pressione Enter pra iniciar."
  
  text_request ="Por favor digite o texto a ser traduzido:"

  language_base = "Selecione o numero do idioma de origem:"

  language_selection = "Selecione o numero do idioma para qual deseja traduzir:"
  
  puts initial_menu
  STDIN.getc

  puts names_list
  puts language_base
  language_index = gets.chomp().to_i
  
  if language_index <= language_names.size && language_index > 0
    name = language_names[language_index-1]
    puts "Idioma selecionado #{name}."
    original_language = language_file.key("#{name}")
    puts "Pressione Enter para continuar:"
    STDIN.getc
  else
    puts "Idioma detectado automáticamente."
    original_language = from
    puts "Pressione Enter para continuar:"
    STDIN.getc
  end

  puts names_list
  puts language_selection

  translation_index = gets.chomp().to_i
  
  if translation_index <= language_names.size && translation_index > 0
    name = language_names[translation_index-1]
    puts "Idioma selecionado #{name}"
    translation_language = language_file.key("#{name}")
    puts "Pressione Enter para continuar:"
    STDIN.getc
  else
    puts "Idioma inválido.\nSeguindo com tradução padrão para Inglês"
    puts "Pressione Enter para continuar:"
    name = "Inglês"
    translation_language = to
    STDIN.getc
  end
  
  puts text_request
  texto_original = gets.chomp()

  texto = translate.traduzindo(original_language,translation_language,texto_original)
  time = Time.now
  puts texto[0]["translations"][0]["text"]
  File.open("#{time.strftime("%d-%m-%Y_%H:%M:%S")}.txt",  "w") do |line|
    line.puts "Texto Original: #{texto_original}"
    line.puts "Traduzido para: #{name}"
    line.puts "Texto Traduzido: #{texto[0]["translations"][0]["text"]}"
    line.puts("Data e Hora da Solicitação: #{time.strftime("%d/%m/%Y %H:%M")}")
  end
  puts "Conteúdo traduzido com sucesso, salvo no arquivo '#{time.strftime("%d-%m-%Y_%H:%M:%S")}.txt'."
  puts "Obrigado por usar o tradutor de texto!"
end