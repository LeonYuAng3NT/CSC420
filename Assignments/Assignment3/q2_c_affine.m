function [affine] = q2_c_affine(f1, f2, match, k)
    sortedMatch = sortrows(match,3);
    P = zeros(2 * k, 6);
    P1 = zeros(2*k,1);
    for i = 1:2:2*k
        matchIdx = (i+1)/2;
        x1 = f1(1, sortedMatch(matchIdx, 1));
        y1 = f1(2, sortedMatch(matchIdx, 1));
        x2 = f2(1, sortedMatch(matchIdx, 2));
        y2 = f2(2, sortedMatch(matchIdx, 2));
        P(i,1) = x1;
        P(i,2) = y1;
        P(i+1,3) = x1;
        P(i+1,4) = y1;
        P(i,5) = 1;
        P(i+1,6) = 1;
        P1(i) = x2;
        P1(i+1) = y2;
    end
    affine = inv(transpose(P) * P) * transpose(P) * P1;
end