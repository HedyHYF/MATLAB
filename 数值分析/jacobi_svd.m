function [U, S, V] = jacobi_svd(A)
B = A'*A;
[S, V]=jacobi(B);
S = abs(diag(S)).^0.5;
% ����ֵ���ݼ����򣬶�Ӧ��V�е���������ҲҪ������
[~, in] = sort(S,'descend');
S = diag(S(in));
V = V(:,in);
U = A*V*diag(1./(diag(S)))';
end

function [matrix,J] = jacobi(matrix)
    THRESHOLD = 1e-8;
    ITERATION = 1e8; 
    J = eye(size(matrix,1));
    iteration = 0;
    while iteration <ITERATION
        pass = true;
%����1�������ǶԽ�Ԫ����ÿһ�ԷǶԽ�Ԫ��jacobi��ת�任
%         for i = 1:size(matrix,1)
%             for j = i+1:size(matrix,1)
%                 [matrix,J,pass] = rotate(matrix, i, j, pass, J);
%             end
%         end
%����2���������õ�����ֵ����һ�ԷǶԽ�Ԫ��������jacobi��ת�任
        [x,y]=max(abs(matrix-diag(diag(matrix))));
        [~,j]=max(x);
        i = y(j);
        [matrix,J,pass] = rotate(matrix, i, j, pass, J);
         %���ǶԽ�Ԫ��ȫ��С����ֵʱֹͣ����
        if pass  
            break;
        end
        %������ֵС����ֵ�ķǶԽ�Ԫ����
        matrix = matrix - diag(diag(matrix).*(diag(matrix)<THRESHOLD));
        iteration = iteration + 1; 
    end

end

function [a, J, pass] = rotate(a, i, j, pass, J)
%����Jacobi��ת����J���Լ�J'*B*J
    THRESHOLD = 1e-8;
    if abs(a(i,j)) < THRESHOLD
        return;
    end
    pass = false;
    c = (a(i,i) - a(j,j)) / (2 * a(i,j));
    t = sign((c>=0)-1/2) / (abs(c) + sqrt(1 + c^2));
    Cos = 1 / sqrt(1 + t^2);
    Sin = Cos * t;
    G = eye(size(a,1));
    G([i j],[i j])=[Cos -Sin;Sin Cos];
    a = G' * a * G;
    J = J * G;
end


  

