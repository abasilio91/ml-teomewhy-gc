with tb_level as (
    select
        idPlayer,
        vlLevel,
        row_number() over (partition by idPlayer order by dtCreatedAt desc) as rnPlayer
    
    from tb_lobby_stats_player

    where dtCreatedAt < {date}
    and dtCreatedAt >= date({date},'-30 days')
), 

tb_level_final as (
    select *
    from tb_level
    where rnPlayer = 1
),

tb_gameplay_stats as (  
    select
        idPlayer,
        count (distinct idLobbyGame) as qtPartidas,
        count (distinct date(dtCreatedAt)) as qtDias,
        cast(min (julianday({date}) - julianday(dtCreatedAt)) as int) as qtRecencia,
        avg(flWinner) as WinRate,
        cast(count (distinct case when descMapName = 'de_mirage' then idLobbyGame end) as FLOAT) / count (distinct idLobbyGame) as propMirage,
        cast(count (distinct case when descMapName = 'de_nuke' then idLobbyGame end) as FLOAT) / count (distinct idLobbyGame) as propNuke,
        cast(count (distinct case when descMapName = 'de_inferno' then idLobbyGame end) as FLOAT) / count (distinct idLobbyGame) as propInferno,
        cast(count (distinct case when descMapName = 'de_vertigo' then idLobbyGame end) as FLOAT) / count (distinct idLobbyGame) as propVertigo,
        cast(count (distinct case when descMapName = 'de_ancient' then idLobbyGame end) as FLOAT) / count (distinct idLobbyGame) as propAncient,
        cast(count (distinct case when descMapName = 'de_dust2' then idLobbyGame end) as FLOAT) / count (distinct idLobbyGame) as propDust2,
        cast(count (distinct case when descMapName = 'de_train' then idLobbyGame end) as FLOAT) / count (distinct idLobbyGame) as propTrain,
        cast(count (distinct case when descMapName = 'de_overpass' then idLobbyGame end) as FLOAT) / count (distinct idLobbyGame) as propOverpass,
        avg(1.0 * qtHs / qtKill) as avgHsRate,
        sum(1.0 * qtHs / qtKill) as vlHsRate,
        cast(count(distinct case when strftime('%w', dtCreatedAt) = '0' then date(dtCreatedAt) end) as float) / count (distinct date(dtCreatedAt)) as propDias00,
        cast(count(distinct case when strftime('%w', dtCreatedAt) = '1' then date(dtCreatedAt) end) as float) / count (distinct date(dtCreatedAt)) as propDias01,
        cast(count(distinct case when strftime('%w', dtCreatedAt) = '2' then date(dtCreatedAt) end) as float) / count (distinct date(dtCreatedAt)) as propDias02,
        cast(count(distinct case when strftime('%w', dtCreatedAt) = '3' then date(dtCreatedAt) end) as float) / count (distinct date(dtCreatedAt)) as propDias03,
        cast(count(distinct case when strftime('%w', dtCreatedAt) = '4' then date(dtCreatedAt) end) as float) / count (distinct date(dtCreatedAt)) as propDias04,
        cast(count(distinct case when strftime('%w', dtCreatedAt) = '5' then date(dtCreatedAt) end) as float) / count (distinct date(dtCreatedAt)) as propDias05,
        cast(count(distinct case when strftime('%w', dtCreatedAt) = '6' then date(dtCreatedAt) end) as float) / count (distinct date(dtCreatedAt)) as propDias06,
        avg(qtKill) as avgKill,
        avg(qtAssist) as avgAssist,
        avg(qtDeath) as avgDeath,
        avg(qtHs) as avgHs,
        avg(qtBombeDefuse) as avgBombeDefuse,
        avg(qtBombePlant) as avgBombePlant,
        avg(qtTk) as avgTk,
        avg(qtTkAssist) as avgTkAssist,
        avg(qt1Kill) as avg1Kill,
        avg(qt2Kill) as avg2Kill,
        avg(qt3Kill) as avg3Kill,
        avg(qt4Kill) as avg4Kill,
        avg(qt5Kill) as avg5Kill,
        avg(qtPlusKill) as avgPlusKill,
        avg(qtFirstKill) as avgFirstKill,
        avg(vlDamage) as avgDamage,
        avg(qtHits) as avgHits,
        avg(qtShots) as avgShots,
        avg(qtLastAlive) as avgLastAlive,
        avg(qtClutchWon) as avgClutchWon,
        avg(qtRoundsPlayed) as avgRoundsPlayed,
        avg(qtSurvived) as avgSurvived,
        avg(qtTrade) as avgTrade,
        avg(qtFlashAssist) as avgFlashAssist,
        avg(qtHitHeadshot) as avgHitHeadshot,
        avg(qtHitChest) as avgHitChest,
        avg(qtHitStomach) as avgHitStomach,
        avg(qtHitLeftAtm) as avgHitLeftAtm,
        avg(qtHitRightArm) as avgHitRightArm,
        avg(qtHitLeftLeg) as avgHitLeftLeg,
        avg(qtHitRightLeg) as avgHitRightLeg

    from tb_lobby_stats_player
    where dtCreatedAt < {date}
    and dtCreatedAt >= date({date},'-30 days')

    group by idPlayer
)

select 
    t1.*,
    t2.vlLevel

from tb_gameplay_stats as t1
left join tb_level_final as t2
on t1.idPlayer = t2.idPlayer