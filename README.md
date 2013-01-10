#IAAC: Control experto (p3) & Control borroso (p6)

###Sistema experto
ejecutar el archivo ```control_experto.m```
 - establece la planta a simular (características)
 - hace la presintonía con ZN
 - simula el sistema y muestra los resultados
 - llama al sistema experto

###Código del sistema experto
archivo ```sistema_experto.m```

###Especificaciones del sistema

####Primera especificación
1. Tiempo de subida: 2.5
2. Tiempo de pico: 15
3. Sobrelongación: 20
4. Tiempo de asentamiento: 40
5. Estado estacionario: 1

####Segunda especificación
1. Tiempo de subida: 2
2. Tiempo de pico: 15
3. Sobrelongación: 15
4. Tiempo de asentamiento: 40
5. Estado estacionario: 1

###Sistema borroso
valores ajustados por sintonía Ziegler-Nichols
 - Kp= 6.3600
 - Ki= 0.4968
 - Kd= 20.3561

###Rango de valores para el control borroso 
####error
```
valores € [-0.3, 1]
valor esperado = 0
```
####integral 
```
valores € [0, 3.5]
valores esperados = [1.3, 1.4] 
valor estable = 1.34
```
###salida
```
valores € [-3, 7]
valores esperados = [0.6, 0.7]
valor estable = [0.667]
```