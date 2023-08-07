brick.SetColorMode(1, 4);
color_rgb = brick.ColorRGB(1);  % Get Color on port 1.
display(color_rgb);                 % Print color code of object
distance = brick.UltrasonicDist(3);  % Get distance to the nearest object.
display(distance);                   % Print distance.
touch = brick.TouchPressed(4); % Read a touch sensor connected to port 4.
global key
InitKeyboard();
key1 = 0;
colorSwitch = 0;
endProgram = 0;
color = 0;

while 1
    switch key1
        case 0 % autonomous driving
           
            brick.MoveMotor('B', -73); % go forward
            brick.MoveMotor('C', -71.15);
     
            distance = brick.UltrasonicDist(3);
            color_rgb = brick.ColorRGB(1);
            touch = brick.TouchPressed(4);
           
            display(color_rgb);        %constant readout if needed
            display(distance);
            disp(color);
   
            color = 0;
            if (color_rgb(1) < 50) && (color_rgb(2) < 90) && (color_rgb(3) > 100)
                color = 2;
            elseif (color_rgb(1) > 140) && (color_rgb(2) < 70) && (color_rgb(3) < 70)
                color = 5;
            elseif (color_rgb(1) < 40) && (color_rgb(2) > 40) && (color_rgb(3) < 40)
                color = 3;
            end
           
           
            if (color == 5) %sees red strips
               
                %stop the car
                brick.StopAllMotors();
                %brick.MoveMotor('B', 0);
                %brick.MoveMotor('C', 0);
                pause(3);%for 3 secs
               
                %color_rgb = brick.ColorRGB(1);%read the color sensor.
                brick.MoveMotor('B', -73); % go forward
                brick.MoveMotor('C', -71.15);
                pause(0.5);
               
            elseif (color == 2 && colorSwitch == 0) % blue square
               % colorSwitch = colorSwitch + 1; %counts number of blue passes
               
                colorSwitch = 1; %only stops on first pass
                   
                key1 = 1;
           
            elseif (color == 3 && colorSwitch == 1) % green square
                    %will it switch to remotecontrol
                    key1 = 1;
           
            elseif touch  %hits wall so it backs up then turns left
              
                brick.beep(); %Beep when touched
                pause(0.03); %For 1 secs
                
                brick.StopAllMotors('Brake');
                pause(0.5);
               
                brick.MoveMotor('BC', 40); %Move back
                pause(0.75);
                brick.StopAllMotors('Brake');
                pause(0.2);
                %Turn
                
                brick.MoveMotorAngleRel('B', -30, 183, 'Brake');
                brick.MoveMotorAngleRel('C', 30, 177, 'Brake');
                brick.WaitForMotor('B');
                brick.WaitForMotor('C');
           
           
            elseif ( distance > 50 && distance < 225) %no wall
                pause(0.95); %delay to get to center of square
                brick.StopAllMotors('Brake');
                pause(0.8);
                brick.MoveMotor('BC', 40); %Move back
                pause(0.3);
                
                brick.MoveMotorAngleRel('B', 28, 208, 'Brake');
                brick.MoveMotorAngleRel('C', -28, 176, 'Brake');
                brick.WaitForMotor('B');
                brick.WaitForMotor('C');
               
                brick.MoveMotor('B', -73); % go forward for a bit
                brick.MoveMotor('C', -71.15); % to avoid rereadingz
                pause(1.75);                  %same no wall
               
               
               
     %       elseif (distance > 250) %program kill
      %          display(distance);
       %         brick.StopAllMotors('Brake');
        %        break;


            end
           
        case 1 % remote control
            brick.StopAllMotors('Brake');
           
            while 1
                pause(0.1);
                switch key
                    case 'uparrow'
                        brick.MoveMotor('BC', -50);
                        pause(0.2);
                        brick.StopAllMotors();
                    case 'downarrow'
                        brick.MoveMotor('BC',50);
                        pause(0.2);
                        brick.StopAllMotors();
                    case 'leftarrow'
                        brick.MoveMotorAngleRel('B', -50, 15);
                        %     brick.ResetMotorAngle('B');
                    case 'rightarrow'
                        brick.MoveMotorAngleRel('C', -50, 15);
                        %     brick.ResetMotorAngle('C');
                    case 's'
                        brick.StopMotor('BC');
                    case 0
                        disp('No Key Pressed!');
                    case 'c'
                        brick.MoveMotorAngleRel('A',-5,20,'Brake');
                        brick.MoveMotorAngleRel('D',5,20,'Brake');
                        
                    case 'v'
                        brick.MoveMotorAngleRel('A',10,30,'Brake');
                        brick.MoveMotorAngleRel('D',-10,30,'Brake');
                        
                       
                    case 'q'
                        break;
                       
                    case 'z'
                        endProgram = 0;
                        endProgram = endProgram + 1;
                        break;
                       
                end
            end
  %Closes Key window
           
            if endProgram >= 1   %end program in
                break;            %remotecontrol just press
            end                   % z
           
            key1 = 0;              %returns to autonomous
    end
end
CloseKeyboard();