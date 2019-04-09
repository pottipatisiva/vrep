clear all;
%% variables
duration=10;
stepsize=0.5;
mat=[];



%% initialization
disp('Program started');
	vrep=remApi('remoteApi'); % using the prototype file (remoteApiProto.m)
	vrep.simxFinish(-1); % just in case, close all opened connections
	clientID=vrep.simxStart('127.0.0.1',19999,true,true,5000,5);
    %%    %% Handle Getters
    % Handles are blocks of code by which we can control objects in scene
    [returnCode,ePuck]    = vrep.simxGetObjectHandle(clientID, 'ePuck',vrep.simx_opmode_blocking);
%for leftjoint
[returnCode,leftMotor ]   = vrep.simxGetObjectHandle(clientID,'ePuck_leftJoint',vrep.simx_opmode_blocking);
%for rightjoint
[returnCode,rightMotor]   = vrep.simxGetObjectHandle(clientID,'ePuck_rightJoint',vrep.simx_opmode_blocking);
%% Position
%first call 
[returnCode,position]      = vrep.simxGetObjectPosition(clientID, ePuck, -1, vrep.simx_opmode_streaming);
[returnCode] = vrep.simxSetJointTargetVelocity(clientID, leftMotor, 3, vrep.simx_opmode_blocking);
[retutnCode] = vrep.simxSetJointTargetVelocity(clientID, rightMotor,3, vrep.simx_opmode_blocking);
                
j=[]
for i=1:stepsize:duration
    [returnCode,position]      = vrep.simxGetObjectPosition(clientID, ePuck, -1, vrep.simx_opmode_buffer);
    mat=[ position; mat]
    pause(0.5);
    j=j+1

end
[returnCode] = vrep.simxSetJointTargetVelocity(clientID, leftMotor, 0, vrep.simx_opmode_blocking);
[retutnCode] = vrep.simxSetJointTargetVelocity(clientID, rightMotor,0, vrep.simx_opmode_blocking);

