Generalidades:
- Todas las funciones y simulink fueron realizados en MatLAB 2023. Si tenés otra versión quizá no puedas abrirlo.
- Para poder utilizar todas las funciones estas se deben encontrar en la misma carpeta que el código.
- Si desea probar los ejemplos muevalós a donde están las funciones.

Funciones:
- anguloCero: Se le pasa una lista de polos y ceros. Se le pasa una posición objetivo (x). La función devuelve dónde debería añadirse un cero para que x pertenezca al lugar de raices.
- anguloPolo: Se le pasa una lista de polos y ceros. Se le pasa una posición objetivo (x). La función devuelve dónde debería añadirse un polo para que x pertenezca al lugar de raices.

- caso1: Función que genera las variables del estimador para poder usar simulink_caso1/ simulink_caso1_adc / simulink_caso1_digital.
- caso2: Función que genera las variables del estimador para poder usar simulink_caso2/ simulink_caso2_adc / simulink_caso2_digital.
- caso3: Función que genera las variables del estimador para poder usar simulink_caso3/ simulink_caso3_adc / simulink_caso3_digital.  (Solo SISO)
- caso4: Función que genera las variables del estimador para poder usar simulink_caso4/ simulink_caso4_adc / simulink_caso4_digital.  (A veces no funciona)

- damping2overshoot: pasa de MP% a epsilon.
- overshoot2damping: pasa de epsilon a MP%.

- rlocusGain: Similar al rlocus. Devuelve el valor K para que el lugar de raices tenga el valor deseado (p_des). (Si no pasa por ahí entregará el más cercano que encontró).

- pidValues: Devuelve las constantes KP, KD, KI de cualquier controlador que se le pase. 

- control: Devuelve los vectores de realimentación de estados y de estimación. También devuelve los prefiltros.
	Como parámetros adicionales se le puede pasar:
	* Polos del estimador (si no se pasan solo calculará realimentación de estados).
	* Rinf y Yinf: valores de entrada y salida en infinito para el cálculo de los prefiltros.
	* Ts: tiempo de muestreo (solo necesario para planta).

- stateFeedback: Devuelve la matriz K de realimentación de estados y la matriz An (A equivalente con realimentación).
- stateEstimator: Devuelve la matriz Ke del estimador.
- prefilterFeedback: Devuelve el prefiltro K0 de realimentación de estados. Posee valores en infinito como parámetros opcionales (Rinf y Yinf).
- prefilterEstimaro: Devuelve el prefiltro K00 del estimador de estados. Posee valores en infinito como parámetros opcionales (Rinf y Yinf).
 
- tf2ssControlable: Similar a tf2ss. Devuelve las matrices canónicas controlables A,B,C,D.

Nota: la función "control" hace exactamente lo mismo que "stateFeedback", "stateEstimator", "prefilterFeedback" y "prefilterEstimaro".

Por favor leer los prototipos de función para saber qué devuelven.
Por favor ver los ejemplos de parciales para chequear el funcionamiento de las funciones.