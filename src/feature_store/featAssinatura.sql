with tb_assinatura_history as (
    SELECT
        t1.idPlayer,
        t2.descMedal,
        count (distinct t1.idMedal) as qtMedalsDist,
        count (t1.idMedal) as qtMedal,
        count (case when t2.descMedal in ('Membro Plus', 'Membro Premium') then t1.idMedal end) as qtAssinaturas,
        count (case when t2.descMedal = 'Membro Plus' then t1.idMedal end) as qtPlus,
        count (case when t2.descMedal = 'Membro Premium' then t1.idMedal end) as qtPremium,
        max (case when t2.descMedal in ('Membro Plus', 'Membro Premium')
            and coalesce (t1.dtRemove, date('now')) > '2022-01-01'
            then 1 else 0 end) as flAssinante

    from tb_players_medalha as t1
    left join tb_medalha as t2

    where t1.dtCreatedAt < t1.dtExpiration
    and t1.dtCreatedAt < coalesce(t1.dtRemove, date('now'))
    and t1.dtCreatedAt < '2022-01-01'
    and coalesce(t1.dtRemove, date('now')) > '2022-01-01'

    group by t1.idPLayer
),

tb_assinatura as(
    select
        t1.*
    
    from tb_players_medalha as t1
    left join tb_medalha as t2
    on t1.idMedal = t2.idMedal
 
    where t1.dtCreatedAt < t1.dtExpiration
    and t1.dtCreatedAt < coalesce(t1.dtRemove, date('now'))
    and t1.dtCreatedAt < '2022-01-01'
    and coalesce(t1.dtRemove, t1.dtExpiration, date('now')) > '2022-01-01'
),

tb_assinatura_rn as (
    SELECT
        *,
        row_number() over (partition by idPlayer order by dtRemove desc) as rn_assinatura
    
    from tb_assinatura
),

tb_assinatura_sumario as (
    SELECT
    *,
    julianday('2022-01-01') - julianday(dtCreatedAt) as qtDiasAssinatura,
    julianday(dtRemove) - julianday('2022-01-01') as qtDiasExpericao

    from tb_assinatura_rn
    where rn_assinatura = 1
    order by idPlayer
)

select 
    '2022-01-01' as dtRef,
    1 as flAssinatura,
    t1.idPlayer,
    t2.descMedal,
    t1.qtDiasAssinatura,
    t1.qtDiasExpericao,
    t2.qtAssinaturas,
    t2.qtPremium,
    t2.qtPlus

from tb_assinatura_sumario as t1
left join tb_assinatura_history as t2
on t1.idPlayer = t2.idPlayer