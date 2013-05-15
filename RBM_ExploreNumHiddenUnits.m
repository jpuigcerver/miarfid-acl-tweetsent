% Load data
%[train, valid]=LoadCrossValidationData();
NCV = length(train);

SIZES = {};
SIZES{1} = [100];
SIZES{2} = [300];
SIZES{3} = [500];
SIZES{4} = [700];
SIZES{5} = [900];
for s=1:length(SIZES)
    rng(0);
    clear dbn
    dbn.sizes = SIZES{s};
    dbn_opts.numepochs = 5;
    dbn_opts.momentum = 0;
    dbn_opts.alpha = 1;
    nn_opts.numepochs = 15;
    nn_opts.plot=1;
    va_errs = zeros(NCV, 1);
    tr_errs = zeros(NCV, 1);
    for i=1:NCV
        dbn_opts.batchsize = size(train{i}.x, 1);
        % DBN pretrain
        fprintf(1, 'Pretraining...\n');
        dbn = dbnsetup(dbn, train{i}.x, dbn_opts);
        dbn = dbntrain(dbn, train{i}.x, dbn_opts);
        % Train NN
        fprintf(1, 'Fine tunning...\n');
        nn_opts.batchsize = size(train{i}.x, 1);
        nn = dbnunfoldtonn(dbn, size(train{i}.y, 2));
        nn.activation_function = 'sigm';
        nn.output = 'softmax';
        nn = nntrain(nn, train{i}.x, train{i}.y, nn_opts, ...
            valid{i}.x, valid{i}.y);
        % Check errors
        [tr_err, ~] = nntest(nn, train{i}.x, train{i}.x);
        [va_err, ~] = nntest(nn, valid{i}.x, valid{i}.y);
        fprintf(1, 'Train error: %f  Valid. error: %f\n', tr_err, va_err);
        va_errs(i) = va_err;
        tr_errs(i) = tr_err;
    end
    va_mean_err = mean(va_errs);
    tr_mean_err = mean(tr_errs);
    va_ci_err = 1.96 * std(va_errs) / sqrt(NCV);
    tr_ci_err = 1.96 * std(tr_errs) / sqrt(NCV);
    fprintf(1, 'TRAIN ERROR = %f (%f, %f)\n', tr_mean_error, ...
        tr_mean_error - tr_ci_err, tr_mean_error + tr_ci_err);
    fprintf(1, 'VALIDATION ERROR = %f (%f, %f)\n', va_mean_error, ...
        va_mean_error - va_ci_err, va_mean_error + va_ci_err);
end
