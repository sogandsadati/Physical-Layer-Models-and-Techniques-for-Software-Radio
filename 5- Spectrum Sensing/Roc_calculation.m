function [Roc_f] = Roc_calculation(f,Ground_truth) %f is the signal, Ground_truth is the reference signal
save_TP_f = [];
save_FP_f = [];
condition_positive = sum(Ground_truth);
condition_negative = length(f) - condition_positive;
for i = 0:0.001:1
    TP_f = 0;
    FP_f = 0;
    for j = 1 : length(f)
        if f(j) > i
            if Ground_truth(j) == 1
                TP_f = TP_f + 1;
            else
                FP_f = FP_f + 1;
            end
        end
    end
    save_TP_f = [save_TP_f TP_f];
    save_FP_f = [save_FP_f FP_f];
end
true_positive_f  = save_TP_f/condition_positive;
false_positive_f = save_FP_f/condition_negative;
Roc_f = [false_positive_f;true_positive_f];
end
