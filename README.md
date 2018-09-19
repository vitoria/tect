# plp-project
# Especificação de Projeto de PLP - тест

### Objetivo

Implementar um sistema de acompanhamento e organização de atividades de teste baseado nos paradigmas imperativo, funcional e lógico, utilizando as seguintes linguagens: C/C++, Haskell e Prolog.

### Descrição

O тест é um sistema de acompanhamento e organização de atividades de teste (execução manual), onde o usuário pode criar um projeto de testes, e nele especificar todo o desenrolar do seu projeto no que diz respeito à testes, desde a criação de casos de testes até os resultados dos mesmos.

### Funcionalidades

- Criar um projeto de testes;
  - Estrutura básica do sistema, que irá conter todas as suítes de testes e os seus respectivos casos.
- Criar suites de testes;
  - Estrutura de organização e agrupamento de casos de teste;
- Criar casos de teste;
  - Devem especificar o objetivo, passos a serem executados e informações adicionais, bem como um conjunto de entradas, condições já estabelecidas e os resultados esperados;
- Organizar os testes em suítes e casos de teste;
- Consultar qualquer informação sobre os testes;
- Inserir dados sobre o estado da execução execução dos testes:
  - Se um teste passou;
  - Se um teste não passou;
  - Se ocorreu um problema ao executá-lo;
  - Se ele não foi executado ainda (estado inicial);
  - Informações adicionais.
- Criar contas de usuário para utilização do sistema;
- Gerar relatórios sobre qualquer conjunto (suítes) de teste:
  - Esses relatórios conteriam informações sobre os dados dos testes e seus resultados, demonstrando qual funcionalidade do projeto foi testada e qual demonstra problema ou necessidade de correção, após a execução dos testes;
- Gerar panorama geral dos testes numa suíte de testes;
  - Exibindo cada caso de teste e seu estado, bem como dados em porcentagem de cada estado para toda a suíte.
- Gerar panorama geral dos testes num projeto de testes;
  - Exibindo os dados numéricos (porcentagens dos estados) de cada suíte contida no projeto.
- Gerar panorama geral da contribuição de determinado usuário do sistema;
  - Exibindo os dados numéricos (porcentagens) da contribuição do usuário selecionado.
- Persistência com a utilização de arquivos.
