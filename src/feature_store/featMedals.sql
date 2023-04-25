SELECT
    {date} as dtReft,
    t1.idPlayer,
    t2.descMedal,
    count (distinct t1.idMedal) as qtMedalsDist,
    count (t1.idMedal) as qtMedal,
    count (case when t2.descMedal in ('Membro Plus', 'Membro Premium') then t1.idMedal end) as qtAssinaturas,
    count (case when t2.descMedal = 'Membro Plus' then t1.idMedal end) as qtPlus,
    count (case when t2.descMedal = 'Membro Premium' then t1.idMedal end) as qtPremium,
    max (case when t2.descMedal in ('Membro Plus', 'Membro Premium')
        and coalesce (t1.dtRemove, date('now')) > {date}
        then 1 else 0 end) as flAssinante

from tb_players_medalha as t1
left join tb_medalha as t2

where t1.dtCreatedAt < t1.dtExpiration
and t1.dtCreatedAt < coalesce(t1.dtRemove, date('now'))
and t1.dtCreatedAt < {date}
and coalesce(t1.dtRemove, date('now')) > {date}

group by t1.idPLayer