with tb_features as (
    SELECT
        t1.*,
        t2.qtPartidas,
        t2.qtDias,
        t2.qtRecencia,
        t2.WinRate,
        t2.propMirage,
        t2.propNuke,
        t2.propInferno,
        t2.propVertigo,
        t2.propAncient,
        t2.propDust2,
        t2.propTrain,
        t2.propOverpass,
        t2.avgHsRate,
        t2.vlHsRate,
        t2.propDias00,
        t2.propDias01,
        t2.propDias02,
        t2.propDias03,
        t2.propDias04,
        t2.propDias05,
        t2.propDias06,
        t2.avgKill,
        t2.avgAssist,
        t2.avgDeath,
        t2.avgHs,
        t2.avgBombeDefuse,
        t2.avgBombePlant,
        t2.avgTk,
        t2.avgTkAssist,
        t2.avg1Kill,
        t2.avg2Kill,
        t2.avg3Kill,
        t2.avg4Kill,
        t2.avg5Kill,
        t2.avgPlusKill,
        t2.avgFirstKill,
        t2.avgDamage,
        t2.avgHits,
        t2.avgShots,
        t2.avgLastAlive,
        t2.avgClutchWon,
        t2.avgRoundsPlayed,
        t2.avgSurvived,
        t2.avgTrade,
        t2.avgFlashAssist,
        t2.avgHitHeadshot,
        t2.avgHitChest,
        t2.avgHitStomach,
        t2.avgHitLeftAtm,
        t2.avgHitRightArm,
        t2.avgHitLeftLeg,
        t2.avgHitRightLeg,
        cast(t2.vlLevel as INT) as vlLevel,
        t3.qtMedalsDist, 
        t3.qtMedal, 
        t3.flAssinante

    from featAssinatura as t1

    left join featGamePlay as t2
    on t1.dtRef = t2.dtRef
    and t1.idPlayer = t2.idPlayer

    left join featMedals as t3
    on t1.dtRef = t3.dtRef
    and t1.idPlayer = t3.idPlayer

    where t1.dtRef <= date('2022-02-28','-30 days')
)

select
    t1.*,
    coalesce(t2.flAssinatura, 0) as flNaoChurn --variável target

from tb_features as t1

left join featAssinatura as t2
on t1.idPlayer = t2.idPlayer
and t1.dtRef = date(t2.dtRef, '-30 days')