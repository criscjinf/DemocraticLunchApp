# app-democratic-lunch
>> Aplicação responsavel por iniciar a votação e registrar os votos

## Dependências
```
DUnit para testes
Biblioteca de componentes Indy 10
Api deve estar rodando na porta 3000
```

### Compilação do projeto
```
Delphi XE 2
```

### Configuração de ambiente
```
Deixei as DCU's e DCP's configuradas em uma pasta separada dentro da pasta padrão para evitar configurações extras.
```

### Parâmetros
```
Nenhum parâmetro implementado 
```

### Testes
```
Subir a api
Rodar o aplicativo DemocraticLunchTests.exe
Clicar em Actions => Run
```

Observações:

>>Para diminuir o tempo de desenvolvimento não implantei telas de cadastro, ficando como melhoria futura.<br>
>> Com o mesmo intuito não foi implementado login por senha

Modo de usar:
- Configure na API o arquivo config, com o horário de encerramento da votação
- Suba a api
- Suba o serviço

- Abra o sistema DemocraticLunch
    -  Caso o sistema identifique uma votação em andamento, será direcionado a tela para informar seu CPF para logar
    - Caso contrário notificará o usuário e perguntará se deseja iniciar uma votação

- Informe o CPF
    -  Se o sistema não localizar, permitirá incluir nome e e-mail para continuar

- Selecione o restaurante que deseja votar e clique em continuar
- Será exibida a tela de votação finalizada


## Vale destacar
| unit| Destaque |
| - | - |
| uObjectBaseApi | Classe base responsável por fazer o parse das informações do sistema para lista de objetos alem de controlar as requisições entre as Views(formulários) e a classe de consumo da api |
| pasta de Helpers | Classes com o objetivo de extender as funcionalidades de alguns componetes para falicitar o desenvolvimento |
| uApiConsumption | Utilizado design pattern Singleton. Permite realizar as comunicação com apis.<br><br> Obs.: Este pattern desta classe foi implementado pensando no consumo de um unica api sem threads ativas no sistema, em outro ambiente não utilizaria o pattern Singleton para permitir consumo de multiplas apis. |

# Evolução do sistema
- Adicionaria as funções de cadastros de restaurantes e funcionários com geranciamento de senha, deixando habilitado somente para o ADM
- Implementaria carregamento de parâmetros a partir de um arquivo config criptografado
- Adicionaria funcionalidade para visualização de histórico de visitas aos restaurantes, com gráficos apresentando quais os restaurantes mais frequentados, permitindo ao usuário tomar decisão de voto baseado em suas experiencias passadas

# Observações finais
> O projeto em Delphi não contempla os cadastros de restaurantes, sendo registrados automaticamente alguns dados Fake pela api.