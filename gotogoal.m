display('Program started');
	vrep=remApi('remoteApi'); % using the prototype file (remoteApiProto.m)
	vrep.simxFinish(-1); % just in case, close all opened connections
	clientID=vrep.simxStart('127.0.0.1',19999,true,true,5000,5);
    
%% Handles

% e-Puck Leader
[returnCode,ePuckLeader]    = vrep.simxGetObjectHandle(clientID, 'ePuck',vrep.simx_opmode_blocking);
[returnCode,leftMotorL]    = vrep.simxGetObjectHandle(clientID,'ePuck_leftJoint',vrep.simx_opmode_blocking);
[returnCode,rightMotorL]   = vrep.simxGetObjectHandle(clientID,'ePuck_rightJoint',vrep.simx_opmode_blocking);

% e-Puck Follower
[returnCode,ePuckF0]        = vrep.simxGetObjectHandle(clientID, 'ePuck_base#0',vrep.simx_opmode_blocking);

[returnCode,leftMotorF0]    = vrep.simxGetObjectHandle(clientID,'ePuck_leftJoint#0',vrep.simx_opmode_blocking);
[returnCode,rightMotorF0]   = vrep.simxGetObjectHandle(clientID,'ePuck_rightJoint#0',vrep.simx_opmode_blocking);
    
%% Set Math

RWheel  = 20.5 * 10^(-3); % in meters
LPuck   = 53 * 10^(-3);   % in meters

vel_F0  = 3;
PGain   = 25;
err = [];
trgt = [];
velL = [];
velR = [];
omega = [];
curr = [];
%%  Leader
  
[returnCode,targetPos]      = vrep.simxGetObjectPosition(clientID, ePuckLeader, -1, vrep.simx_opmode_streaming);
[returnCode,currentPosF0]   = vrep.simxGetObjectPosition(clientID, ePuckF0, -1, vrep.simx_opmode_streaming);
[returnCode,currentOriF0]   = vrep.simxGetObjectOrientation(clientID, ePuckF0, -1, vrep.simx_opmode_streaming);

pause(1)
%% 

[returnCode] = vrep.simxSetJointTargetVelocity(clientID, leftMotorL, 3, vrep.simx_opmode_blocking);
[retutnCode] = vrep.simxSetJointTargetVelocity(clientID, rightMotorL,3, vrep.simx_opmode_blocking);


            for i=0.5:0.5:100
                i
                % Update Pose
                [returnCode,targetPos]      = vrep.simxGetObjectPosition(clientID, ePuckLeader, -1, vrep.simx_opmode_buffer);
                [returnCode,currentPosF0]   = vrep.simxGetObjectPosition(clientID, ePuckF0, -1, vrep.simx_opmode_buffer);
                [returnCode,currentOriF0]   = vrep.simxGetObjectOrientation(clientID, ePuckF0, -1, vrep.simx_opmode_buffer);
                
                % Controller
           
                target_angF0 = atan2(targetPos(2)-currentPosF0(2),targetPos(1)-currentPosF0(1));
                curr_angF0   = atan2(sin(currentOriF0(3)),cos(currentOriF0(3)))
                
                error_angF0  = target_angF0 - curr_angF0;                
                error_angF0  = atan2(sin(error_angF0),cos(error_angF0));                

                omegaF0      = -PGain * error_angF0;
                
                omega = [omega omegaF0];
                curr = [curr; currentOriF0(3)];
                trgt = [trgt target_angF0];
                err  = [err error_angF0]
    
                
                % Unicycle to Differential 
                vL = (2*vel_F0 + omegaF0*LPuck)/(2);
                vR = (2*vel_F0 - omegaF0*LPuck)/(2);
                
                velL = [velL vL];
                velR = [velR vR];
                
                % velocity
                
                [returnCode] = vrep.simxSetJointTargetVelocity(clientID, leftMotorF0, vL, vrep.simx_opmode_blocking);
                [retutnCode] = vrep.simxSetJointTargetVelocity(clientID, rightMotorF0,vR, vrep.simx_opmode_blocking);
                
                pause(0.5);
                
            end
                
   