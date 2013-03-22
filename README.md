StayCool
================

Autor: Cawe Coy Rodrigues Marega

Esta é uma rede social simples onde o usuário pode buscar e adicionar amigos, gerenciar grupos, publicar conteúdos, curtir, comentar e ainda obter estatísticas sobre a participação dos usuários em seu ciclo social.

Trata-se de é um aplicativo web desenvolvido em Java / JSP / HTML / CSS / JS que roda sob um servidor Tomcat e utiliza o banco de dados PostgreSQL. O desenvolvimento foi feito com o NetBeans IDE.

::Criando Banco de dados

1. Instale o PostgreSQL (anote o usuário e senha que a instalação irá te pedir)
2. Abra o pgAdmin III
3. Crie uma Nova Conexão (ícone da tomada), entrando apenas com os seguintes dados:

* nome: qualquer nome... (por padrão: testes)
* host: localhost
* port: 5432
* username: seu usuário que usou na instalação do PostgreSQL (por padrão: postgres)
* password: sua senha que usou na instalação do PostgreSQL (por padrão: marega)

4. Duplo clique na conexão que acabou de criar. Digite a senha.
5. Crie um banco de dados: clique com o botão direito no ícone do banco de dados -> New Database
6. Entre apenas com o seguinte nome do seu banco de dados: testes. Clique em Ok.
7. No menu superior, clique no ícone SQL.
8. Copie e cole TODO o conteúdo de script_criar_banco.sql nessa nova janela. Clique em 'Run' (ícone de play).
9. Agora o banco de dados já está razoavelmente populado

::Configurando NetBeans

1. Certifique-se de ter a última versão do NetBeans instalada, e com o plugin "Java Web Applications" instalado
2. Clique em File -> Open Project
3. Vá até a pasta "Rede" e abra-a
4. Insera o Driver do Postgre no seu projeto "Rede" do NetBeans:

* Clique com o botão direito do mouse em cima do nome do projeto (no caso "Rede").
* Escolha a opção "Propriedades".
* janela que abrir, em "Categorias", escolha "Bibliotecas".
* Clique no botão "Adicionar JAR/pasta".
* Selecione o driver do Postgre postgresql-9.1-902.jdbc4.jar (está na mesma pasta este LEIA ME).

::Configurando conexão com banco de dados

1. No seu projeto no NetBeans, abra todas as classes Java.
2. No menu, clique em Find -> Replace...
3. Então, para todas as classes Java, mande o NetBeans substituir a linha abaixo por uma equivalente com os dados do seu servidor e banco de dados
DriverManager.getConnection("jdbc:postgresql://host:port/dbname","username","password");

* No caso da nossa configuração, fica:
DriverManager.getConnection("jdbc:postgresql://localhost:5432/testes","seu usuário","sua senha");


* Observação (IMPORTANTE): ao apresentar o trabalho, não se esqueça de trocar "localhost" e "port" pelo "IP e Porta para conexão do servidor onde está o seu banco de dados", que geralmente é o PC do professor. Se necessário, troque também o "dbname", o "username" e o "password".

::Verificando pasta de imagens

- Certifique-se de que a seguinte pasta existe: "[trabalho bd]/Rede/build/web/Files"
- Essa é a pasta onde as classes "Imagem.java" e "Post.java" salvam as imagens
- Dentro dessa pasta encontra-se o "avatar.png" que é a foto de perfil por default de todos os usuarios que não tem foto de perfil
- Se "Rede/build/web/Files" não existir, copie a pasta "Files" que se encontra na mesma pasta deste LEIA-ME e cole em "Rede/build/web" antes de rodar o projeto

::Rodando o projeto

- No NetBeans, clique em Run -> Run Project
- Seja feliz! (:

::Estudando o projeto

- Confira o arquivo "Estudo.txt" na pasta "Estudo" para obter dicar básicas para estudar o projeto

:: Observação

Confesso que o código da aplicação está bastante sujos, pois as prioridades eram:

- Banco de dados
- Aplicativo funcionando
