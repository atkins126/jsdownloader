# JSDownloader | Download de arquivos com Delphi + Multithread + SQLite

Olá, seja bem-vindo ao meu projeto Delphi.

Essa aplicação realiza o download de arquivos a partir de um link utilizando o sistema de Multithread nativo do Delphi combinado com o design pattern de Observer para receber os callbaks e armazenar o histórico de downloads em um banco de dados SQLite.

# Estrutura do banco SQLite
- Tabela - LOGDOWNLOAD
- Campos 
  - codigo - number(22,0) not null | Auto inc.
  - url - varchar(600) not null
  - datainicio - datetime not null
  - datafim - datetime
