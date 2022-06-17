# UNL PVJ3 Actividad 5 Final en Godot Engine #
**Version del documento 0.0.1**
**16/06/2022**

## Idea ##
**Recreacion del juego Battle City de NES en Godot Engine** *(ver seccion referencias para un gameplay)*
La idea principal es recrear el clasico de NES para mejorar mi comprension de Godot como engine para juegos

## Concepto de juego ##
El jugador se pone a los mandos de un tanque que debe defender a su base del ataque de sucesivas oleadas de enemigos a traves de una serie de niveles de creciente dificultad

## Caracteristicas principales ##
A continuacion pasaremos a detallar algunas de las caracteristicas del juego

#### **Jugador** ####
El jugador controla un tanque que cuenta con la posibilidad de disparar para eliminar a los enemigos del nivel antes que ellos destruyan su base.
Comportamiento:
* El tanque puede moverse en 4 direcciones (arriba/abajo/izquierda/derecha) y disparar hacia donde mira
Vidas:
* El tanque del jugador cuenta con una cantidad limitada de *"vidas o intentos"*
* Cada vez que un enemigo le de con un disparo al jugador, el jugador perdera una vida.
Diferentes tipos de disparo y cuenta con municion ilimitada:
* Normal: el que puede disparar la municion mas rapidamente. *Rapido, con daño normal, sin efecto grafico*.
* Cargado: el que debe acumular energia (durante un tiempo) para disparar. *Lento, con daño aumentado, con efecto grafico*.
Punto de inicio del jugador:
* Cada vez que inicie un nivel o el jugador pierda una vida (si todavia le queda alguna), volvera a reaparecer en el mismo punto.
* Al perder una vida, el jugador debera esperar un lapso de tiempo para reaparecer. Los enemigos siguen moviendose

#### **Enemigos** ####
Habra diferentes tipos de enemigos con diferente velocidad de movimiento y cadencia de disparo
Comportamiento:
* Los enemigos se mueven por el mapa aleatoriamente y disparando a intervalos de tiempo
Vida:
* Los enemigos cuentan con una cantidad limite de disparos que puede recibir de parte del jugador
Generacion:
* La generacion de enemigos sera en puntos especificos del mapa seleccionados de forma aleatoria

#### **Niveles** ####
Los niveles seran tilemaps con diferentes tipos de elementos que el jugador puede usar para su ventaja
* Roca: no se puede atravesar ni se destruye con disparos
* Ladrillo: se rompe con los disparos
* Agua: no se puede atravesar
* Vegetacion: se puede atrasevar

#### **Base** ####
Sera un punto fijo en el mapa que el jugador debera defender impidiendo que los enemigos le disparen
Vida:
* La base estara resguardada con ladrillos que los enemigos deberan atravesar antes de disparar al centro de la base
* El centro de la base solo soporta un disparo enemigo
* Si los enemigos destruyen la base, el nivel se reinicia

#### **Power-ups** ####
Cada nivel contara con un listado de power-ups que podran aparecer aleatoriamente en el mapa
* Escudo para el tanque con limite de tiempo
* Escudo para la base con limite de tiempo
* Eliminar todos los enemigos actualmente en el nivel

## Objetivos ##
El jugador debera defender su base (un objeto fijo en el mapa) de las sucesivas oleadas de enemigos que iran apareciendo el nivel hasta superar todos los niveles.
* Victoria: Si derrota a todos los enemigos del nivel
* Derrota: Si pierde todas sus vidas o si algun enemigo le dispara al centro de la base

## Desafios ##
El jugador debera defender su base de los ataques enemigos y tratar que los enemigos no destruyan su tanque.

## Genero ##
Juego de accion Top-Down 2D

### Referencias: ###
[Battle City NES Gameplay](https://www.youtube.com/watch?v=YqaDd1oAApU)