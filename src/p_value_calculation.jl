function p_to_log_odds(p, background_frequencie = 0.25f0 )
    q = 1-p
    odds = q/(1-q)
    log_odds = log2(odds)
    return log_odds
end

function log_odds_to_p(log_ods)
    ods = 2^log_ods
    q = ods/(ods+1)
    p = 1-q
    return p
end