function pid=sistema_experto(pid,num,den,espec)

% Simulamos el modelo
  [tout,yout]=simular(pid,num,den);
    
% Calculo de las caracteristicas del sistema
  [tr,tp,Mp,ts,ys]=caracteristicas(tout,yout);
  [tout,yout]=simular(pid,num,den,tr,tp,Mp,ts,ys);
  
% Abrimos el modelo Simulink
  open_system('modelo');
  disp(' ');
  disp(' Pulse enter para ejecutar el control experto');
  pause;
  
    salir = 0;

  while ~salir
      modificado = 0;
      % tr muy bajo, aumentarlo
      if  (espec(1))<tr && ~modificado
        %aumento kp
         pid(1)=pid(1)+0.05; 
         pid(3)=pid(3)+0.03;
          modificado = 1;
          
      % tr alto, disminurilo
      elseif (espec(1))>tr && ~modificado
         %disminuimos kp
         pid(1)=pid(1)-0.08;
          modificado = 1;
      end
        
      % sobrelongacion bajo, aumentar
      if (espec(3)) < Mp && ~modificado
        pid(3)=pid(3)+0.03;
          modificado = 1;
          
      % sobrelongacion alto, disminuir
      elseif (espec(3)) > Mp && ~modificado
        pid(3)=pid(3)-0.03;
          modificado = 1;
      end
      

      
      
      
      % Caracteristicas del sistema bajo la nueva situacion
         [tout,yout]=simular(pid,num,den,tr,tp,Mp,ts,ys);
         [tr,tp,Mp,ts,ys]=caracteristicas(tout,yout);
      
          % Si se cumplen las especificaciones, entonces salir
         if  (tr<=espec(1)&& Mp<espec(3))|| ~modificado
            salir=1;
         end
         
  end
  
  [tout,yout]=simular(pid,num,den,tr,tp,Mp,ts,ys);
  disp(' ');
  disp(' PID sintonizado, pulse enter para salir');
  pause;
  
% Cerramos el modelo Simulink
  close_system('modelo');