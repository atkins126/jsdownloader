# JSDownloader | Download de arquivos com Delphi 10.4 + Multithread + SQLite3

Olá, seja bem-vindo ao meu projeto em Delphi 10.4.

Essa aplicação realiza o download de arquivos a partir de um link utilizando o sistema de Multithread nativo do Delphi combinado com o design pattern de Observer para receber os callbaks e armazenar o histórico de downloads em um banco de dados SQLite.

# Estrutura do banco SQLite
- Tabela - LOGDOWNLOAD
- Campos 
  - codigo - number(22,0) not null | Auto inc.
  - url - varchar(600) not null
  - datainicio - datetime not null
  - datafim - datetime

# Funcionalidades
- Iniciar download
  - Realiza o download a partir do link informado.
- Exibir mennsagem
  - Exibe uma mensagem com o progresso total do download até o momento, em percentual.
- Parar download
  - Interrompe o download, apenas.
- Exibir histórico de downloads
  - Abre uma nova janela com uma lista onde exibe todo o histórico de logs de download armazenados.

# Preview
![image](https://user-images.githubusercontent.com/33349637/163734409-cf17714f-03a0-4dbb-a7d7-226a070a6fe1.png)
