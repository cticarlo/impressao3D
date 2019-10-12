espessura = 2;              //espessura da parede (2mm)
raio = 10;                  //raio interno
altura = 18;                //altura interna
largura_aba = 10;           //largura da aba do suporte
raio_furo = 2.5;            // raio do furo para parafuso


module small_cylinder (){   //parte interna
    $fn=500;                //quantidade de lados do polígono
    cylinder(r = raio, h = altura);    //cria cilindro 
}

module external_cylinder () {   //parte externa
    $fn = 500;                  //quantidade de lados do polígono
    cylinder(r = raio+espessura, h = altura+espessura); //cria cilindro 
} 

module etapa_1 (){          //módulo da diferença entre o volume de
    difference (){          //external_cylinder e o small_cylinder
        external_cylinder ();
        translate ([0,0, espessura])
        small_cylinder ();
    }
} 

module aba_direita (){      //parte lateral direita, agrupar um cubo e um
    $fn=500;               //cilindro            
    union ()
    {
      cube([largura_aba, 10, espessura], center=true); // cubo na origem
      translate ([5, 0, 0])  // cilindro é posicionado 5 no eixo x
      cylinder(r = largura_aba/2, h = espessura, center=true); //cria
    }                                                       //cilindro
}

module aba_esquerda (){  // módulo similar ao anterior, apenas posicionando
    $fn=500;            // o cilindro em -5 no eixo x
    union ()
    {
      cube([largura_aba, 10, espessura], center =true);
      translate ([-5, 0, 0])  
      cylinder(r = largura_aba/2, h = espessura, center=true);
    }
}

module etapa_2 (){      //agrupar etapa_1 (cilindro) com as abas laterais
    union()
    {
        etapa_1();
        translate ([12, 0, espessura/2]) //posiciona em 12 no eixo x e 
        aba_direita();                      //na altura (z) do cilindro
        translate ([-12, 0, espessura/2]) //posiciona em -12 no eixo x e
        aba_esquerda();                     //na altura (z) do cilindro
     }
}

module furo (){         //cilindro do furo
    $fn=500;
    cylinder(raio = raio_furo, h = espessura);
}
module etapa_3 (){      //subtração do volume da etapa_2 do volume dos 
    difference ()       //furos
    {
        etapa_2 ();
        translate ([18,0,0])    //posiciona o furo em 18 no eixo x
        furo();
        translate ([-18,0,0])   //posiciona o furo em -18 no eixo x
        furo();
    }
} 
module corte (){                        //corte lateral 
    cube([10, 5,18], center = true);    // cubo localizado na origem
}

module etapa_4 (){      //subtração do volume da etapa_3 do volume dos 
    difference (){      // cortes laterais
        etapa_3 ();
        translate ([0,10,11.5]) //posiciona 10 no eixo y e 11.5 no z
        corte ();
        translate ([0,-10,11.5])//posiciona -10 no eixo y e 11.5 no z
        corte ();
    }
}
//chamando as funções criadas acima:
//small_cylinder();
//external_cylinder();
//etapa_1();
//aba_direita();
//aba_esquerda();
//etapa_2();
//furo ();
//etapa_3 ();
//corte();
etapa_4 ();