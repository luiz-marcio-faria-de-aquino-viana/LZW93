# LZW93
Programa de compactação e descompactação de arquivos que implementa o algoritmo LZW, desenvolvido durante o período de Graduação em Engenharia Elétrica com Ênfase em Engenharia de Sistemas e Computação na UERJ - Universidade do Estado do Rio de Janeiro (entre 1989-1997).

Disciplina: Lógica de Programação: Teoria e Aplicação (em 1993/1). 

Professor: João Araújo, D.Sc. (http://www.desc.eng.uerj.br/teacher/jo%C3%A3o-araujo/)

Prazo de dezenvolvimento: 15 dias

Autor (100%): Luiz Marcio Faria de Aquino Viana, Pós-D.Sc.

Este trabalho individual, foi desenvolvido usando a Linguagem de Programação PASCAL.

Neste trabalho foi desenvolvido um compactador e descompactador de arquivos usando o algoritmo LZW (Wikipédia: Lempel–Ziv–Welch (LZW); https://en.wikipedia.org/wiki/Lempel%E2%80%93Ziv%E2%80%93Welch).

Este programa foi implementado para Microcomputador IBM-PC (https://en.wikipedia.org/wiki/IBM_Personal_Computer) e para o Mainframe IBM 390 (https://en.wikipedia.org/wiki/IBM_System/390).

A implementação do algoritmo LZW, usa uma estrutura em árvore binária duplamente encadeada, e surpreendeu o Professor João Araújo, D.Sc. durante a apresentação deste "Trabalho Nota 10!".

CURIOSIDADES:

- Podemos observar no cabeçalho: Copyright (C) 1993, TML (Turma Muito Louca) Software Inc. All Right Reserved.

- Em Agosto/2000, abri a minha empresa de Engenharia e Tecnologia, TLMV Consultoria LTDA - CNPJ: 03.999.590/0001-04, localizada em Magé - RJ - Brasil.

- Em Fevereiro/2012, efetuei a transferência da empresa para o Rio de Janeiro - RJ - Brasil, e a razão social foi alterada para TLMV (Tecnologia Luiz Marcio Viana) Consultoria e Sistemas EIRELI - CNPJ: 03.999.590/0001-04 (YouTube: https://www.youtube.com/@tlmv6436).

ESTRUTURA DE DADOS:

{ Structure Element
 -------------------

  TypeElement

        +-+---+---+-+
        | |   |   | |
        +-+---+---+-+
         |  |   |  |
         |  |   |  +------------------ NextElement
         |  |   +------------- CodeOfElement
         |  +----------- KeyOfElement
         +-------- NextList

}

{  List Example
  --------------

    PointerToFirst
    -------------+
                 |  +-+--+-+  +-+--+-+  +-+--+-+  +-+--+-+
                 +--|*|  |*|--|*|  |*|--|*|  |*|--|*|  |*|--+
                    +-+--+-+  +-+--+-+  +-+--+-+  +-+--+-+  |
                     |         |         |         |        |
                     |         |         |        Nil      Nil
                     |         |         |
                     |         |        +-+--+-+  +-+--+-+
                     |         |        |*|  |*|--|*|  |*|--+
                     |         |        +-+--+-+  +-+--+-+  |
                     |         |         |         |        |
                     |         |        Nil       Nil      Nil
                     |         |
                     |        +-+--+-+  +-+--+-+
                     |        |*|  |*|--|*|  |*|--+
                     |        +-+--+-+  +-+--+-+  |
                     |         |         |        |
                     |        Nil        |       Nil
                     |                   |
                     |                  +-+--+-+
                     |                  |*|  |*|--+
                     |                  +-+--+-+  |
                     |                   |        |
                     |                  Nil      Nil
                     |
                    +-+--+-+  +-+--+-+  +-+--+-+
                    |*|  |*|--|*|  |*|--|*|  |*|--+
                    +-+--+-+  +-+--+-+  +-+--+-+  |
                     |         |         |        |
                    Nil       Nil       Nil      Nil
}
