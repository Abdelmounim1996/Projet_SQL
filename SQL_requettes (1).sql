--question: 1)

SELECT nom,prénom FROM E_personnel WHERE poste=' médecin '
 /
--question:2 )
SELECT COUNT(*),E.nom FROM E_service E 
       INNER JOIN E_affecter A
             on E.code=A.code
        INNER JOIN E_personnel P
            on A.i_insee=P.num_INSEE
            where P.poste=' infirmier '
GROUP BY E.Nom 
/
--question:3 )
select pati.nom,pati.prénom,pati.date_arrivee from E_patients Pati 
       inner join E_souffrir s
             on Pati.num_INSEE=s.num_INSEE
       inner join E_pathologie pat 
             on s.path_code=pat.pathologie_code and pat.pathologie_nom='diabète' 
ORDER BY Pati.date_arrivee DESC 
/

--question:4) Combien de patients ont reçu un soin dans le service cardiologie en 2015 ?
select count(pati.num_INSEE) count_patient from  E_intervention inter
       inner join E_patients pati on inter.patient_INSEE =pati.num_INSEE and inter.date_intervention like '%/15'
        inner join E_SALLE sal
            on inter.code=sal.code and inter.numero_salle=sal.numero_salle 
        inner join E_service ser
            on sal.code=ser.code and ser.Nom=' cardiologie ' 
/
--Question 5:) Quelle est la durée maximale de visite d’un patient depuis 2017?
select MAX(date_sortie-date_arrivee) date_jours from E_patients WHERE date_arrivee > TO_DATE(' 2017/01/01 ','yyyy/mm/dd')
/



--Question 6:) Quels médecins travaillent à la fois dans les services pédiatrie et cardiologie ?
SELECT nom FROM (select nom,count(service) mycount from (select pers.nom,pers.prénom,ser1.nom service from E_personnel pers
       inner join E_affecter aff
             on pers.num_INSEE=aff.i_insee and pers.poste=' médecin '
       inner join E_service ser1 
             on aff.code=ser1.code and ser1.Nom in (' pédiatrie ',' cardiologie ')) group by nom) WHERE mycount=2 
/

--Question 7:) Quels patients ont reçu un soin de la part du Dr. Rachoul, triés par ordre d'arrivée ?

select pers.nom nom_medcin,pat.nom nom_patient,pat.prénom prenom_patient ,pat.date_arrivee date_de_arrivee from E_personnel pers
       inner join E_intervention inter
             on pers.num_INSEE=inter.num_INSEE and pers.nom=' Rachoul '
       inner join E_patients pat 
             on inter.patient_INSEE=pat.num_INSEE
order by pat.date_arrivee DESC 
/

--Question 8:)Afficher les salles de pédiatrie triées selon le nombre de soins (décroissant) en 2020 ?

SELECT * from (SELECT E_SALLE.numero_salle num_salle, E_SALLE.volume_salle V ,E_SALLE.taux_occupation TAUX,inter.nom ,inter.date_intervention FROM E_SALLE 
       inner join E_SERVICE 
            ON E_SALLE.code=E_SERVICE.code AND E_SERVICE.nom=' pédiatrie '
        inner join E_intervention inter 
            on E_SALLE.code=inter.code and E_SALLE.numero_salle=inter.numero_salle ) T
inner join (select nom,count(nom) from E_intervention inter where inter.date_intervention like '%/20' group by nom order by count(nom) DESC) TT on T.nom=TT.nom
 /


--Question 9:)Quel médecin a effectué le plus de soins en 2015 ?

SELECT pers.nom,pers.prénom,mycount from  E_personnel pers
       inner join E_intervention inter
             on pers.num_INSEE=inter.num_INSEE and pers.poste=' médecin '
       inner join (SELECT * FROM (SELECT num_INSEE,count(num_INSEE) mycount 
FROM E_intervention inter where inter.date_intervention like '%/15' GROUP BY num_INSEE order by count(num_INSEE) DESC) ) T
  on inter.num_INSEE=T.num_INSEE and ROWNUM = 1 
/

--Question 10) Le soin “greffe de rein" a-t-il plus de résultats positifs que négatifs (OUI, NON) ?
SELECT resultat FROM (SELECT count(resultat) mycount, resultat from E_intervention where nom=' greffe de rein ' group by resultat order by mycount desc) T 
WHERE ROWNUM = 1
 /

--Question 11): Affichez les soins qui ont un coût moyen supérieur 1000 euros, classés par coût.

SELECT * FROM (SELECT nom nom_soin,AVG(cout) AVG_count from E_intervention inter group by nom 
order by AVG(cout)) where AVG_count>1000 order by AVG_count 
/

--Question 12):Pour chaque soin, afficher le nom du médecin ayant l’intervention la plus chère
select pers.nom,pers.prénom,T.cout from (SELECT inter.num_INSEE,inter.nom,inter.cout from E_intervention inter 
inner join (select nom,MAX(cout) max_cout from E_intervention group by nom) TMAX
 on inter.cout=TMAX.max_cout) T 
 inner join E_personnel pers On pers.num_INSEE=T.num_INSEE 
 /

--Question 13): Affichez les patients qui ont une durée moyenne de séjour supérieure à 15 jours.
SELECT * from E_patients where date_sortie-date_arrivee>=15 
/


--Question 14): Quels médecins travaillant en pédiatrie ont reçu une greffe de rein en 2020 ?
SELECT * from E_personnel pers inner join E_intervention inter on pers.num_INSEE=inter.num_INSEE and inter.nom=' greffe de rein ' and pers.poste=' médecin '
inner join E_SERVICE on inter.code=E_SERVICE.code and E_SERVICE.nom=' pédiatrie ' and inter.date_intervention like '%/20' 
/

--Question 15):Quels infirmiers travaillent dans l’ensemble des services de l'hôpital ?


select * from (SELECT num_INSEE,count(nom_service) mycount FROM 
(SELECT pers.num_INSEE,pers.nom DR_nom,pers.prénom DR_prenom,E_SERVICE.nom nom_service from E_personnel pers 
inner join E_affecter afct on pers.num_INSEE=afct.i_insee and pers.poste=' infirmier '
inner join E_SERVICE E_SERVICE on afct.code=E_SERVICE.code) group by num_INSEE) 
where mycount=(select count(*) from E_SERVICE) 
/

