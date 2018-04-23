function minMeanResidualSSD = ransacReassemble(f1, f2, match, iterations)
    minMeanResidualSSD = intmax;
    
    for i = 1 : iterations
        k = 5;
        [matchSize, ~] = size(match);
        idx = randperm(matchSize, k);

        P = zeros(2 * k, 6);
        P1 = zeros(2*k,1);
        for j = 1:2:2*k
            matchIdx = idx((j+1)/2);
            x1 = f1(1, match(matchIdx, 1));
            y1 = f1(2, match(matchIdx, 1));
            x2 = f2(1, match(matchIdx, 2));
            y2 = f2(2, match(matchIdx, 2));
            P(j,1) = x1;
            P(j,2) = y1;
            P(j+1,3) = x1;
            P(j+1,4) = y1;
            P(j,5) = 1;
            P(j+1,6) = 1;
            P1(j) = x2;
            P1(j+1) = y2;
        end

        affine = inv(transpose(P) * P) * transpose(P) * P1;
        A = zeros(2,3);
        A(1, 1) = affine(1);
        A(1, 2) = affine(2);
        A(2, 1) = affine(3);
        A(2, 2) = affine(4);
        A(1, 3) = affine(5);
        A(2, 3) = affine(6);

        residualSum = 0;
        for j = 1:matchSize
            point1 = [f1(1, match(j, 1)); f1(2, match(j, 1)); 1];
            point2 = [f2(1, match(j, 2)), f2(2, match(j, 2))];
            point2Fitted = A * point1;
            dist = pdist2(point2, ctranspose(point2Fitted));
            residualSum = residualSum + dist ^ 2;
        end
        meanResidualSSD = residualSum / matchSize;
        if meanResidualSSD < minMeanResidualSSD
            minMeanResidualSSD = meanResidualSSD;
        end
    end
end