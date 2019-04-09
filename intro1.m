%% Developed by Siva
% Dependencies: vrepintro.ttt
%% % Make sure to have the server side running in V-REP: 
% in a child script of a V-REP scene, add following command
% to be executed just once, at simulation start:
%
% simRemoteApi.start(19999)
%
% then start simulation, and run this program.
%
%% %% Remote API Intialization

	disp('Program started');
	vrep=remApi('remoteApi'); % using the prototype file (remoteApiProto.m)
	vrep.simxFinish(-1); % just in case, close all opened connections
	clientID=vrep.simxStart('127.0.0.1',19999,true,true,5000,5);
    %% Handle Getters
    % Hamdles are blocks of code by which we can control objects in scene
    


[returnCode,ePuck]    = vrep.simxGetObjectHandle(clientID, 'ePuck',vrep.simx_opmode_blocking);
[returnCode,ePuckbase]        = vrep.simxGetObjectHandle(clientID, 'ePuck_base',vrep.simx_opmode_blocking);
[returnCode,leftMotorL]    = vrep.simxGetObjectHandle(clientID,'ePuck_leftJoint',vrep.simx_opmode_blocking);
[returnCode,rightMotorL]   = vrep.simxGetObjectHandle(clientID,'ePuck_rightJoint',vrep.simx_opmode_blocking);

%% 
%Position
vel_F0=5;

[returnCode] = vrep.simxSetJointTargetVelocity(clientID, leftMotorL,vel_F0 ,vrep.simx_opmode_blocking);
[returnCode] = vrep.simxSetJointTargetVelocity(clientID, rightMotorL, vel_F0,vrep.simx_opmode_blocking);
pause(5);
[returnCode] = vrep.simxSetJointTargetVelocity(clientID, leftMotorL,0 ,vrep.simx_opmode_blocking);
[returnCode] = vrep.simxSetJointTargetVelocity(clientID, rightMotorL,0,vrep.simx_opmode_blocking);