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
  
% --------------------------

% Incrementar o decrementar las especificaciones
%  if tr<=espec(1), incrementar_tr=1; else incrementar_tr=0; end
%  if tp<=espec(2), incrementar_tp=1; else incrementar_tp=0; end   
%  if Mp<=espec(3), incrementar_Mp=1; else incrementar_Mp=0; end   
%  if ts<=espec(4), incrementar_ts=1; else incrementar_ts=0; end   
%  if ys<=espec(5), incrementar_ys=1; else incrementar_ys=0; end   
  
% Reglas del sistema experto para adaptar las caracteristicas a las especificaciones
  salir=0;
  tiempoSubida=0;
  elong=0;
  
  while ~salir 
     %% Reglas para tiempo subida
     if ((tr>espec(1)*2) && ~(tiempoSubida))
        aviso=1
         %pid(1)=pid(1)*1.75;
        pid(1)=pid(1)+3.5;
        tiempoSubida=1;
     end
     if ((tr>espec(1)*1.75) && (tr<=espec(1)*2) && ~(tiempoSubida))  
        aviso=2
         %pid(1)=pid(1)*1.5;
        pid(1) = pid(1)+2.5;
        tiempoSubida=1;
     end
     if ((tr>espec(1)*1.5) && (tr<=espec(1)*1.75) && ~(tiempoSubida))
         aviso=3
         %pid(2)=pid(2)*1.75;
         pid(2)=pid(2)+0.3;
         %pid(1)=pid(1)*1.25;
         pid(1)=pid(1)+1.5;
         tiempoSubida=1;
     end
     if ((tr>espec(1)*1.25) && (tr<=espec(1)*1.5) && ~(tiempoSubida))
        aviso=4
        %pid(2)=pid(2)*1.5;
        pid(2)=pid(2)+0.3;
        pid(1)=pid(1)+1;
        tiempoSubida=1;
     end
     if ((tr>espec(1)) && (tr<=espec(1)*1.25) && ~(tiempoSubida))
        aviso=5
        pid(2)=pid(2) + 0.2;
        pid(1)=pid(1)+0.5;
        tiempoSubida=1;
     end
     % disminuir kp     
     if ((espec(1))>tr && ~(tiempoSubida))
        aviso=6
         pid(1)=pid(1)-0.08;
        tiempoSubida=1;
     end 
    %% Reglas para sobrelongacion
    if ((Mp>espec(3)*2) && ~(elong))
        pid(2)=pid(2)*0.1;
        elong=1;
    end
    if ((Mp>espec(3)*1.75) && (Mp<=espec(3)*2)  && ~(elong))
        pid(2)=pid(2)*0.35;
        elong=1;
    end
    if ((Mp>espec(3)*1.5) && (Mp<=espec(3)*1.75)  && ~(elong))
        pid(3)=pid(3)*1.1;
        elong=1;
    end
    if ((Mp>espec(3)*1.25) && (Mp<=espec(3)*1.5)  && ~(elong))
        pid(2)=pid(2)*0.67;
        elong=1;
    end
    if ((Mp>espec(3)) && (Mp<=espec(3)*1.25)  && ~(elong))
        pid(1)=pid(1)*0.63;
        elong=1;
    end
    % disminuir sobrelongacion
    if ((espec(3)) > Mp && ~(elong)) 
        pid(3)=pid(3)-0.03;
        elong=1;
    end
    
    %% Nueva situacion
    % Caracteristicas del sistema bajo la nueva situacion
    [tout,yout]=simular(pid,num,den,tr,tp,Mp,ts,ys);
    [tr,tp,Mp,ts,ys]=caracteristicas(tout,yout);
    
    % Si se cumplen las especificaciones, entonces salir
    if ( (tr <= espec(1)&& Mp<espec(3)) || (~(tiempoSubida) && ~(elong)) )
            salir=1;
    else               
        tiempoSubida=0;
        elong=0;
    end    
   end
  
% ---------------------------

  [tout,yout]=simular(pid,num,den,tr,tp,Mp,ts,ys);
  disp(' ');
  disp(' PID sintonizado, pulse enter para salir');
  pause;
  
% Cerramos el modelo Simulink
  close_system('modelo');