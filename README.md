# UNL PVJ3 Actividad 5 Final en Godot Engine #
**Version del documento 0.1.0** (igual a `config/version` de `project.godot`; `1.0.0` en la entrega)
**12/11/2026**

## Itch.io ##
[Battle City UNL](https://manfabv.itch.io/battle-city-unl) (se juega en el navegador)

## Idea ##
**Recreacion del juego Battle City de NES en Godot Engine** *(ver seccion referencias para un gameplay)*
La idea principal es recrear el clasico de NES para mejorar mi comprension de Godot como engine para juegos **ademas de añadir conceptos de Twin Stick Shooter y 3D**.

## Concepto de juego ##
El jugador se pone a los mandos de un tanque que debe defender a su base del ataque de sucesivas oleadas de enemigos a traves de una serie de niveles de creciente dificultad

## Caracteristicas principales ##
A continuacion pasaremos a detallar algunas de las caracteristicas del juego

#### **Jugador** ####
El jugador controla un tanque que cuenta con la posibilidad de disparar para eliminar a los enemigos del nivel antes que ellos destruyan su base.

Comportamiento:
* El tanque se mueve en cualquier direccion y apunta de forma independiente (twin stick): con el mouse o con el stick derecho. *(Cambio respecto al GDD evaluado: el original movia en 4 direcciones.)*

Vidas:
* El tanque del jugador cuenta con una cantidad limitada de *"vidas o intentos"*
* Cada vida tiene puntos de vida (3, 4 o 5 segun el nivel de mejora del tanque). Cada disparo enemigo que acierta quita entre 1 y 3 puntos segun el tipo de enemigo; al llegar a 0 el jugador pierde esa vida. *(Cambio respecto al GDD evaluado: decia que cada acierto quitaba una vida.)*

Diferentes tipos de disparo segun su nivel de mejora (la estrella sube de nivel), con municion ilimitada:
* Nivel 0 (lento): proyectil lento, 1 de daño, 0.5 s entre disparos, con efecto grafico.
* Nivel 1 (normal): 2 de daño, 0.25 s entre disparos.
* Nivel 2 (doble rapido): dos cañones, 3 de daño, 0.125 s entre disparos.

Estado de vida critica:
* Cuando la vida del tanque baja de un umbral configurable, se activa un efecto grafico de energia como advertencia. Jugador y enemigos usan el mismo criterio (un umbral de vida por arquetipo). *(Cambio: el GDD hablaba de vidas para el jugador y de disparos para los enemigos; el disparo cargado se quito.)*

Punto de inicio del jugador:
* Cada vez que inicie un nivel o el jugador pierda una vida (si todavia le queda alguna), volvera a reaparecer en el mismo punto.
* Al perder una vida, el jugador debera esperar un lapso de tiempo para reaparecer. Los enemigos siguen moviendose

#### **Enemigos** ####
Habra diferentes tipos de enemigos con diferente velocidad de movimiento y cadencia de disparo

Comportamiento:
* Los enemigos se mueven por el mapa aleatoriamente y disparando a intervalos de tiempo
* Cada enemigo tiene un rango de vision configurable, que se ve en el editor como un anillo alrededor del tanque

Vida:
* Los enemigos cuentan con una cantidad limite de disparos que puede recibir de parte del jugador

Estado de vida critica:
* El mismo efecto y el mismo criterio de umbral que el jugador.

Generacion:
* Cada nivel define una linea de tiempo de enemigos: que tipo, cuantos segundos despues del anterior y en que punto, fijo o aleatorio entre los del nivel. Un maximo de enemigos vivos a la vez frena la linea de tiempo.

#### **Niveles** ####
Los niveles seran gridmaps con un suelo, con diferentes tipos de elementos que el jugador puede usar para su ventaja
* Roca: no se puede atravesar ni se destruye con disparos
* Ladrillo: se rompe con los disparos
* Agua: no se puede atravesar
* Vegetacion: se puede atrasevar

#### **Base** ####
Sera un punto fijo en el mapa que el jugador debera defender impidiendo que los enemigos le disparen

Vida:
* La base estara resguardada con ladrillos que los enemigos deberan atravesar antes de disparar al centro
* El centro de la base solo soporta un disparo enemigo
* Si los enemigos destruyen la base, se pierde la partida *(cambio: el GDD decia que el nivel se reiniciaba y se perdia una vida)*

#### **Power-ups** ####
Cada nivel contara con un listado de power-ups que podran aparecer aleatoriamente en el mapa
* Escudo: para el tanque con limite de tiempo
* Escudo: para la base con limite de tiempo
* Eliminar: todos los enemigos actualmente en el nivel
* Estrella: sube de nivel al tanque (mejora sus stats, vida y arma); en el nivel maximo le rellena la vida
* Velocidad: aplica un modificador que aumenta la velocidad del tanque; tomar otro mientras dura lo reemplaza y reinicia la duracion (no se acumula)

## Flujo de juego ##
Menu principal → Jugar → nivel 1 → nivel 2 → nivel 3 → victoria. Perder (base destruida o sin vidas) lleva a la pantalla de derrota, desde donde se vuelve a jugar desde el nivel 1. Pausa con Esc, P o Start en cualquier momento del nivel, incluso mientras el jugador espera para reaparecer. Opciones: volumen de musica y efectos, guardado entre sesiones.

## Controles ##
| Accion | Teclado y mouse | Gamepad |
|---|---|---|
| Moverse | WASD o flechas | stick izquierdo |
| Apuntar | mouse | stick derecho |
| Disparar | click izquierdo (mantener) | gatillo derecho (mantener) |
| Pausa | Esc o P | Start |

## Objetivos ##
El jugador debera defender su base (un objeto fijo en el mapa) de las sucesivas oleadas de enemigos que iran apareciendo el nivel hasta superar todos los niveles.
* Victoria: Si derrota a todos los enemigos del nivel
* Derrota: Si pierde todas sus vidas o si algun enemigo le dispara al centro de la base

## Desafios ##
El jugador debera defender su base de los ataques enemigos y tratar que los enemigos no destruyan su tanque para asi sobrevivir todas las oleadas de enemigos del nivel para avanzar al siguiente.

## Genero ##
Juego de accion Twin Stick Shooter 3D con vista Top-Down

## Arquitectura (una linea por sistema) ##
* `BaseEvent`, `TimerManagerResource`, `TintedMaterialsResource` y `AudioSettingsResource`: servicios compartidos como `Resource` inyectados por export (sin autoloads). Los eventos anuncian hechos; cada listener decide.
* `SceneManager`: unico dueño de la escena activa y de la pausa.
* `SpawnManager` + estrategias Once (base), Lives (jugador), Timeline (enemigos) e Interval (power-ups), configuradas por nivel.
* `EntityLevelManager`: configura stats, vida, arma y color de cada nivel de una entidad; el root solo orquesta.
* `Weapon` + `WeaponConfig`: el tipo de arma es una escena con sus cañones; cadencia, velocidad, daño y vida del proyectil son datos del `WeaponConfig`.
* Mundo: `world_base.tscn` con todo lo comun y un `world_NN.tscn` heredado por nivel (layout, spawn points, configs, navmesh).
## Política de Colaboración con IA ##
Este proyecto utiliza Inteligencia Artificial como consultor, herramienta de brainstorming y para implementar los refactors que yo decido aplicar. La arquitectura, las decisiones de diseño, la decisión de qué refactors aplicar, la integración final del código y la optimización del sistema son responsabilidad del autor.

Mi flujo de desarrollo incluye:
* Brainstorming: exploración de alternativas y detección de posibles mejoras.
* Validación de restricciones: análisis de ventajas y desventajas de mis diseños específicos.
* Revisión puntual: contraste de errores o riesgos antes de integrar un cambio.
* Implementacion de refactors o simplificaciones: primero analizo yo cuales mejoras puedo aplicar y despues dejo que la IA las implemente, de a una tarea; reviso cada cambio antes de integrarlo.
* Consulta de metodos y API del engine: es el uso mas extensivo que le doy. Por ejemplo, como se marca un destino en una navigation region o que metodo usar para una tarea puntual de Godot.

La IA no es el autor principal de las ideas ni de los assets. Las sugerencias se revisan, adaptan y se aplican.
Esto quiere decir que la IA consulta y, despues de que yo analizo que mejoras puedo aplicar, implementa los refactors; no es usada para vibe coding


## Recursos de aprendizaje: ##
* [Principal: UNL](https://www.unl.edu.ar/carreras/tecnicatura-en-diseno-y-programacion-de-videojuegos-2/)
* [Godot Documentation](https://docs.godotengine.org/en/stable/)
* [HUMBLE BUNDLE – GAME DEV 2024 – TIER 3](https://academy.zenva.com/product/humble-bundle-game-dev-2024-tier-3/)
* [Complete Godot 3D](https://www.udemy.com/course/complete-godot-3d/)
* [Godot 4 Shaders](https://www.udemy.com/course/godot-4-shaders/)
* [Godot 4: Build an Action RPG](https://www.udemy.com/course/godot-rpg/)
* [Godot - VFX for Games - Beginner to Intermediate](https://www.udemy.com/course/godot-vfx-for-games/)
* [Godot 4 Best Practices: Practical techniques and strategies for efficient, scalable game development](https://www.packtpub.com/en-us/product/godot-4-best-practices-9781835467824)

## Referencias: ##
* [Battle City NES Gameplay](https://www.youtube.com/watch?v=YqaDd1oAApU)
* [Assault Android Cactus+](https://www.youtube.com/watch?v=1StvcYeEdaU)