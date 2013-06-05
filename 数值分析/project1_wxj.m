clear all;
clc;
% ��������
SIZE = 100;
EPS = 1e-8;
TIMES = 99;
NUM1 = 200;
NUM2 = 100;
% ����5��100�׶Խ���D(:,:,1) -- D(:,:,5)
D = zeros(SIZE,SIZE,5);
D(:,:,1) = diag([100,80*rand(1,SIZE-2)+10,1]);%�м�����ֵ�ֲ���Χ��
D(:,:,2) = diag([100,42*rand(1,SIZE-2)+10,1]);%�м�����ֵƫ����Сֵ���ֲ���Χ��
D(:,:,3) = diag([100,42*rand(1,SIZE-2)+50,1]);%�м�����ֵƫ�����ֵ���ֲ���Χ��
D(:,:,4) = diag([100,8*rand(1,SIZE-2)+80,1]);%�м�����ֵƫ�����ֵ���ֲ���ΧС
D(:,:,5) = diag([100,8*rand(1,SIZE-2)+10,1]);%�м�����ֵƫ����Сֵ���ֲ���ΧС

% �������10��100�׷���M(:,:,1) --M(:,:,10)
% ����M(:,:,i)QR�ֽ�ΪQ(:,:,i)R(:,:,i)
M = zeros(SIZE,SIZE,10);
Q = zeros(SIZE,SIZE,10);
R = zeros(SIZE,SIZE,10);
for i = 1:10
   M(:,:,i) = TIMES*rand(SIZE,SIZE);
   [Q(:,:,i),R(:,:,i)] = qr(M(:,:,i));
end
%����õ�A(:,:,i,j)
A = zeros(SIZE,SIZE,5,10);
for i = 1:5
    for j = 1:10
        A(:,:,i,j) = Q(:,:,j)*D(:,:,i)*(Q(:,:,j).');        
    end
end
%�������һ������b������õ���ȷ�� X(:,:,i,j) = inv(A(:,:,i,j))*b
b = TIMES*rand(SIZE,1);
X = zeros(SIZE,1,5,10);
for i = 1:5
    for j = 1:10
        X(:,:,i,j) = Q(:,:,j)*(inv(D(:,:,i)))*(Q(:,:,j).')*b;        
    end
end

%�����½�����A(:,:,i,j)*x1=b
x1 = zeros(SIZE,1,5,10); 
e1 = zeros(SIZE,NUM1,5,10);
for i = 1:5
    for j = 1:10
        r = b;
        k = 1;
        e1(:,1,i,j) = x1(:,:,i,j) - X(:,:,i,j);
        while norm(r)>EPS
            k = k+1;
            x1(:,:,i,j) = x1(:,:,i,j) + (r'*r)/(r'*(A(:,:,i,j)*r))*r; 
            if k < NUM1+1
                e1(:,k,i,j) = x1(:,:,i,j) - X(:,:,i,j);
            end
            r = b - A(:,:,i,j)*x1(:,:,i,j);    
        end
    end
end
%g�����ݶȷ���A(:,:,i,j)*x2=b
x2 = zeros(SIZE,1,5,10); 
e2 = zeros(SIZE,NUM2,5,10);
for i = 1:5
    for j = 1:10
        rtmp = b;    
        p = rtmp;
        e2(:,1,i,j) = x2(:,:,i,j) - X(:,:,i,j);
        x2(:,:,i,j) =  x2(:,:,i,j) + (rtmp'*p)/(p'*A(:,:,i,j)*p)*p;
        e2(:,2,i,j) = x2(:,:,i,j) - X(:,:,i,j);
        r = rtmp - (rtmp'*p)/(p'*A(:,:,i,j)*p)*A(:,:,i,j)*p;
        k = 2;
        while norm(r)>EPS
            k = k+1;
            p = r + p*(r'*r)/(rtmp'*rtmp);
            x2(:,:,i,j) = x2(:,:,i,j) + (rtmp'*p)/(p'*(A(:,:,i,j)*p))*p;
            if k<NUM2+1
                e2(:,k,i,j) = x2(:,:,i,j) - X(:,:,i,j);
            end
            rtmp = r;
            r = rtmp - (rtmp'*p)/(p'*A(:,:,i,j)*p)*A(:,:,i,j)*p;    
        end
    end
end
%���������½�����������
t1 = zeros(1,NUM1-1,5,10);
for i = 1:5
    for j = 1:10
        for k = 1:NUM1-1
            t1(:,k,i,j) = ((e1(:,k+1,i,j)'*A(:,:,i,j)*e1(:,k+1,i,j))^0.5)/...
            ((e1(:,k,i,j)'*A(:,:,i,j)*e1(:,k,i,j))^0.5);
        end
    end
end
%���㹲���ݶȷ���������
t2 = zeros(1,NUM2-1,5,10);
for i = 1:5
    for j = 1:10
        for k = 1:NUM2-1
            if e2(:,k+1,i,j) ~= 0
                t2(:,k,i,j) = ((e2(:,k+1,i,j)'*A(:,:,i,j)*e2(:,k+1,i,j))^0.5)/...
                ((e2(:,k,i,j)'*A(:,:,i,j)*e2(:,k,i,j))^0.5);
            end
        end
    end
end
%��������ͼ
for i = 1:5
    figure;
    subplot(2,2,1),plot(t1(:,:,i,1));
    subplot(2,2,2),plot(t2(:,:,i,1));
    subplot(2,2,3:4),plot(D(:,:,i),ones(1,100),'*');
end
for i = 1:5
    fprintf('��A[%i][1]���������ʾ�ֵ��%e\n',i,sum(t1(:,:,i,1))/size(t1(:,:,i,1),2));
    fprintf('��A[%i][1]�������½�������%i�εĲ�ֵ��2������%e\n',i,NUM1,(e1(:,NUM1,i,1)'*e1(:,NUM1,i,1))^0.5);
end
for i = 1:5
    fprintf('��A[%i][1]���������ʾ�ֵ��%e\n',i,sum(t2(:,:,i,1))/size(t2(:,:,i,1),2));
    fprintf('��A[%i][1]�������ݶȷ�����%i�εĲ�ֵ��2������%e\n',i,NUM2,(e2(:,NUM2,i,1)'*e2(:,NUM2,i,1))^0.5);
end
