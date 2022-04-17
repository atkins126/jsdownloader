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
![image](https://user-images.githubusercontent.com/33349637/163701353-9f2a2a8f-5ce5-4fc0-a2c7-b36d2a91c2ff.png)
