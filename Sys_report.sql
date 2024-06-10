----Системный отчет по судебным делам-------------------
WITH event_data AS (
    SELECT
        p."Id",
        CASE
            WHEN e."MaxStartDate" IS NULL THEN NULL
            ELSE TO_TIMESTAMP(TO_CHAR(e."MaxStartDate" + INTERVAL '3 hours', 'YYYY-MM-DD HH24:MI'), 'YYYY-MM-DD HH24:MI')::timestamp WITHOUT time zone
        END AS "Дата заседания",
        ROW_NUMBER() OVER (PARTITION BY p."Id" ORDER BY e."MaxStartDate" DESC NULLS LAST) AS rn
    FROM "CaseMap"."Projects" p
    LEFT JOIN (
        SELECT
            e."ProjectId",
            MAX(e."StartDate") AS "MaxStartDate"
        FROM "CaseMap"."Events" e
        JOIN "CaseMap"."EventTypes" et ON et."Id" = e."EventTypeId" AND et."Name" IN ('Заседание', 'Событие СОЮ - заседание')
        GROUP BY e."ProjectId"
    ) e ON e."ProjectId" = p."Id"
    GROUP BY p."Id", e."MaxStartDate"
)
SELECT
    "Id",
    "Дата заседания"
INTO tempTable
FROM event_data
WHERE rn = 1 OR "Дата заседания" IS null ;



select * into tempTable2 from (
SELECT distinct                                                                                                                                                                                                                                   
    p."Id",
    AS1."Дата возникновения спора AC" as "Дата возникновения спора",                                                                                                                                                                                                                                                                                                                                                         
    AS1."NumberAS" as "№ дела",
        case 
    	when Vid_suda."Вид суда" = 'Арбитражный суд (АС)' then Instance."Суд АС"
    	when Vid_suda."Вид суда"  = 'Суд общей юрисдикции (СОЮ)' then InstanceSOU."Суд СОЮ"
    	else null
   	END as "Орган",                                                                                                                                                                                                                                                                                                                                                                         
    istec."Имя истца", 
    Defendant."Имя ответчика",
    thirdPerson."Имя третье лицо",
    CONCAT_WS( '; ',
        CASE WHEN istec."Имя истца ingroup" IS NOT NULL THEN 'Истец' END,
        CASE WHEN Defendant."Имя ответчика ingroup" IS NOT NULL THEN 'Ответчик' END,
        CASE WHEN thirdPerson."Имя третье лицо ingroup" IS NOT NULL THEN 'Третье лицо' END
    ) AS "Компания Группы",
    ConsultantYN."Consultant" as "Привлеченный консультант",
    Probability."Вероятность решения спора в пользу Компании Группы",
    AS1."Категория спора",                                                                                                                                                                                                                  
    AS1."Вид спора",                                                                                                                                                                                                                        
    AS1."Характер спора",                                                                                                                                                                                                                   
    SumaZad."Сумма требований, заявлено",
    SumaZad."Основной долг, заявлено",
    SumaZad."Штрафные санкции, заявлено",
    SumaZad."Моральный вред, заявлено",
    SumaZad."Госпошлина, заявлено",
    SumaZad."Судебные издержки, заявлено",
    SumaZad."Сумма требований, удовлетворено",
    SumaZad."Основной долг, удовлетворено",
    SumaZad."Штрафные санкции, удовлетворено",
    SumaZad."Моральный вред, удовлетворено",
    SumaZad."Госпошлина, удовлетворено",
    SumaZad."Судебные издержки, удовлетворено",
    SumaZad."Сумма требований, исполнено",
    SumaZad."Основной долг, исполнено",
    SumaZad."Штрафные санкции, исполнено",
    SumaZad."Моральный вред, исполнено",
    SumaZad."Госпошлина, исполнено",
    SumaZad."Судебные издержки, исполнено",	
    SumaZad2."ВИ Сумма требований, предъявлено",
    SumaZad2."ВИ Основной долг, предъявлено",
    SumaZad2."ВИ Штрафные санкции, предъявлено",
    SumaZad2."ВИ Моральный вред, предъявлено",
    SumaZad2."ВИ Госпошлина, предъявлено",
    SumaZad2."ВИ Судебные издержки, предъявлено",
    SumaZad2."ВИ Сумма требований, взыскано судом",
    SumaZad2."ВИ Основной долг, взыскано судом",
    SumaZad2."ВИ Штрафные санкции, взыскано судом",
    SumaZad2."ВИ Моральный вред, взыскано судом",
    SumaZad2."ВИ Госпошлина, взыскано судом",
    SumaZad2."ВИ Судебные издержки, взыскано судом",
    SumaZad2."ВИ Сумма требований, исполнено",
    SumaZad2."ВИ Основной долг, исполнено",
    SumaZad2."ВИ Штрафные санкции, исполнено",
    SumaZad2."ВИ Моральный вред, исполнено",
    SumaZad2."ВИ Госпошлина, исполнено",
    SumaZad2."ВИ Судебные издержки, исполнено",  
    up2."DisplayName"  as "Ответственный юрист",
    status."Статус",
    case 
    	when Vid_suda."Вид суда" = 'Арбитражный суд (АС)' then instance."Инстанция"
    	when Vid_suda."Вид суда"  = 'Суд общей юрисдикции (СОЮ)' then InstanceSOU."ИнстанцияСОЮ"
    	else null
   	END as "Инстанция",
	AS1."Встречный иск",
    CASE
        WHEN AS1."Встречный иск" = 'Не подан' THEN AS1."Экономический эффект"
        ELSE EcoEffVIsk."Экономический эффект по встречному иску" + AS1."Экономический эффект"
    END AS "Экономический эффект общий",
    AS1."Дата завершения спора",
    AS1."Результат",
    p."FullNumber" as "Номер дела",
	Vid_suda."Вид суда" 
    
FROM                                                                                                                                                                                                                                        
    "CaseMap"."Projects" p 
    JOIN "CaseMap"."ProjectTypes" pt
                               ON pt."Id" = p."ProjectTypeId"
                          JOIN "Security"."UserProfiles" up2 
                               ON up2."Id" = p."ResponsibleId"
                          JOIN "CaseMap"."ProjectStages" ps
                               ON ps."Id" = p."StageId"

                               
left join (     
SELECT                                                                                                                                                                                                                                  
	        pvb."ProjectId",                                                                                                                                                                                                                    
	        uddi7."Name" as "Вероятность решения спора в пользу Компании Группы"                                                                                                                                                                                                      
	    FROM "DataBlocks"."Block_568b254d-cf7f-40a4-a04e-7d0f1181764a" AS b                                                                                                                                                                     
	    LEFT JOIN "CaseMap"."ProjectVisualBlocks" AS pvb ON pvb."Id" = b."ProjectVisualBlockId"                                                                                                                                                 
	    left JOIN "CaseMap"."UserDefinedDictionaryItems" uddi7 ON uddi7."Id" = b."75363dac-46e1-4976-9abc-48123b0a3a8a"   	    
) Probability on Probability."ProjectId" = p."Id" 
                               
left join ( 
select p."Id",
	CASE
        WHEN ps."Name" IN ('На рассмотрении', 'Исполнение') THEN 'Незавершенные'
        WHEN ps."Name" = 'Завершено' THEN 'Завершенные'
    END AS "Статус",
    ps."Name" as "Стадия"
FROM "CaseMap"."Projects" p 
    JOIN "CaseMap"."ProjectStages" ps ON ps."Id" = p."StageId"
) status on status."Id" = p."Id"
                               
LEFT JOIN (                                                                                                                                                                                                                                 
		SELECT                                                                                                                                                                                                                              
		    pvb."ProjectId",                                                                                                                                                                                                                        
		    TO_DATE(TO_CHAR(b."4ec00734-50d7-4b96-9842-b356daf313de", 'YYYY-MM-DD'),'YYYY-MM-DD HH24:MI') AS "Дата возникновения спора AC",                                                                                                                                                              
		    b."61146c88-f738-4a6d-8884-c127bb69587d" AS "NumberAS",                                                                                                                                                                            
		    uddi."Name" AS "Категория спора",                                                                                                                                                                                                       
		    uddi1."Name" AS "Вид спора",                                                                                                                                                                                                            
		    uddi2."Name" AS "Характер спора",
		    b."2ee83066-9f23-4b48-85cb-1a8819cdf37a" as "Экономический эффект",
		    TO_DATE(TO_CHAR(b."82374382-7b18-4851-8e99-3c62165a9188", 'YYYY-MM-DD'),'YYYY-MM-DD HH24:MI') as "Дата завершения спора",
		    uddi3."Name" as "Результат",
		        CASE
		        WHEN b."ca6d5482-cc4a-4d6a-b65c-313b99209d7e" = True THEN 'Подан'
		        ELSE 'Не подан'
		    END AS "Встречный иск"
		FROM "DataBlocks"."Block_568b254d-cf7f-40a4-a04e-7d0f1181764a" AS b                                                                                                                                                                         
		LEFT JOIN "CaseMap"."ProjectVisualBlocks" AS pvb ON pvb."Id" = b."ProjectVisualBlockId"                                                                                                                                                     
		left JOIN "CaseMap"."UserDefinedDictionaryItems" uddi ON uddi."Id" = b."00231fdc-df5e-4c3a-a74b-bce8ed7c7512"                                                                                                                                    
		left JOIN "CaseMap"."UserDefinedDictionaryItems" uddi1 ON uddi1."Id" = b."4d74fc03-8625-45e9-93c9-b97fa40da48d"                                                                                                                                  
		left JOIN "CaseMap"."UserDefinedDictionaryItems" uddi2 ON uddi2."Id" = b."371dd504-aede-4485-976e-ecc4ca8c871d"
		left JOIN "CaseMap"."UserDefinedDictionaryItems" uddi3 ON uddi3."Id" = b."499d1b90-cc3c-4b06-ace5-c35e62eba2e4"
) AS AS1 ON AS1."ProjectId" = p."Id"                                                                                                                                                                                                        
                                                                                                                                                                                                                                            
JOIN (                                                                                                                                                                                                                                 
		SELECT
		    pvb."ProjectId",
		    STRING_AGG(p."DisplayName", '; ') AS "Имя истца",
		    STRING_AGG(CASE WHEN l."da15d24c-e396-42c9-b67d-3aa55537616e" THEN p."DisplayName" END, '; ') FILTER (WHERE l."da15d24c-e396-42c9-b67d-3aa55537616e") AS "Имя истца ingroup",
		    STRING_AGG(CASE WHEN l."da15d24c-e396-42c9-b67d-3aa55537616e" THEN 'Да' ELSE 'Нет' END, '; ') AS "Входит в группу"
		FROM "DataBlocks"."Line_cafee918-6d3d-4697-8533-7361ce2734a3" AS l
		left JOIN "CaseMap"."ProjectVisualBlocks" AS pvb ON pvb."Id" = l."ProjectVisualBlockId"
		left JOIN "CaseMap"."Participants" AS p ON p."Id" = l."663a64d0-9402-418f-ba0a-304e71f1466b"
		WHERE  ({condition:c5})
		GROUP BY pvb."ProjectId"                                                                                                                                                                                                         
) AS istec ON istec."ProjectId" = p."Id"                                                                                                                                                                                                    
                                                                                                                                                                                                                                            
JOIN (                                                                                                                                                                                                                                 
	    SELECT                                                                                                                                                                                                                                  
	        pvb."ProjectId",                                                                                                                                                                                                                    
	        STRING_AGG(p."DisplayName", '; ') AS "Имя ответчика", 
	 		STRING_AGG(CASE WHEN l."b581aa87-b40f-49bd-9ed7-2e2f756606f3" THEN p."DisplayName" END, '; ') FILTER (WHERE l."b581aa87-b40f-49bd-9ed7-2e2f756606f3") AS "Имя ответчика ingroup",
	        STRING_AGG(CASE WHEN l."b581aa87-b40f-49bd-9ed7-2e2f756606f3" = True THEN p."DisplayName" END, '; ') AS "Входит в группу"
	    FROM                                                                                                                                                                                                                                    
	        "DataBlocks"."Line_724f4d43-a2db-4301-b7d1-f203c21d56ae" AS l                                                                                                                                                                       
	    left JOIN "CaseMap"."ProjectVisualBlocks" AS pvb ON pvb."Id" = l."ProjectVisualBlockId"                                                                                                                                                  
	    left JOIN "CaseMap"."Participants" AS p ON p."Id" = l."0b6c970a-4241-458a-8d70-2b638d9e5dc0"
		where ({condition:c6})                                                                                                                                             
	    group by pvb."ProjectId"                                                                                                                                                                                                            
) AS Defendant ON Defendant."ProjectId" = p."Id"                                                                                                                                                                                            
                                                                                                                                                                                                                                            
JOIN (                                                                                                                                                                                                                                 
	    SELECT                                                                                                                                                                                                                                  
	        pvb."ProjectId",                                                                                                                                                                                                                    
	        STRING_AGG(p."DisplayName", '; ') AS "Имя третье лицо",
	        STRING_AGG(CASE WHEN l."4863ea52-04a5-4086-96d4-42fde1fc21fd" THEN p."DisplayName" END, '; ') FILTER (WHERE l."4863ea52-04a5-4086-96d4-42fde1fc21fd") AS "Имя третье лицо ingroup",
	        STRING_AGG(CASE WHEN l."4863ea52-04a5-4086-96d4-42fde1fc21fd" = True THEN p."DisplayName" END, '; ') AS "Входит в группу"
	    FROM                                                                                                                                                                                                                                    
	        "DataBlocks"."Line_c42db447-8487-4ab9-8ef6-8ab60ab405d2" AS l                                                                                                                                                                       
	    left JOIN "CaseMap"."ProjectVisualBlocks" AS pvb ON pvb."Id" = l."ProjectVisualBlockId"                                                                                                                                                  
	    left JOIN "CaseMap"."Participants" AS p ON p."Id" = l."725c5403-4a7f-48bc-bf82-17510ee27106" 
		where ({condition:c7})                                                                                                                                            
	    group by pvb."ProjectId"                                                                                                                                                                                                            
) AS thirdPerson ON thirdPerson."ProjectId" = p."Id"                                                                                                                                                                                        

LEFT JOIN (                                                                                                                                                                                                                                 
	    SELECT                                                                                                                                                                                                                                  
	        pvb."ProjectId",                                                                                                                                                                                                                    
	        Vid_suda."Name" as "Вид суда"                                                                                                                                                                                                      
	    FROM "DataBlocks"."Block_a0deaeba-ea89-49db-83fb-01869a340546" AS b                                                                                                                                                                     
	    LEFT JOIN "CaseMap"."ProjectVisualBlocks" AS pvb ON pvb."Id" = b."ProjectVisualBlockId"                                                                                                                                                 
	    LEFT JOIN "CaseMap"."UserDefinedDictionaryItems" AS Vid_suda ON Vid_suda."Id" = b."be07a8a4-3d2d-4640-839e-538b97582227"                                                                                                          
) AS Vid_suda ON Vid_suda."ProjectId" = p."Id"                                                                                                                                                                                           
                                                                                                                                                                                                                                            
LEFT JOIN (                                                                                                                                                                                                                                 
		select                                                                                                                                                                                                                                
			pvb."ProjectId"                                                                                                                                                                                                                     
	        ,STRING_AGG(p."DisplayName", ', ')  as "Consultant"
	    FROM "DataBlocks"."Line_226fa2d3-8dab-496e-ad6c-4bdca8de5249" AS l                                                                                                                                                                
			 left JOIN "CaseMap"."ProjectVisualBlocks" as pvb on pvb."Id" = l."ProjectVisualBlockId"
			 left JOIN "CaseMap"."Participants" AS p ON p."Id" = l."07401c2b-b482-4731-b40d-452ec263b9e6"
			group by pvb."ProjectId"
) as ConsultantYN on ConsultantYN."ProjectId" = p."Id"                                                                                                                                                                                      

---------Денежные требования обычный иск-------------
left join (                                                                                                                                                                                                                                 
SELECT                                                                                                                                                                                                                              
    		pvb."ProjectId",                      
    		(CAST(b."9584bc7a-6799-4dec-90c8-d2063c1223ce" AS numeric)) as "Сумма требований, заявлено",
    		(CAST(b."620780e4-d03b-45ea-ac7a-4b140644a30a" AS numeric)) as "Основной долг, заявлено",
    		(CAST(b."4046b262-cd77-43ef-81dc-0e5a0fa35506" AS numeric)) as "Штрафные санкции, заявлено",
    		(CAST(b."9f10e1b8-2b04-4f7a-baee-ade7be112add" AS numeric)) as "Моральный вред, заявлено",
    		(CAST(b."d7704f7f-cff4-44ab-80a0-be189c70bf22" AS numeric)) as "Госпошлина, заявлено",
    		(CAST(b."7e1f6b1b-3ee1-4c41-9645-5be59ef96cd2" AS numeric)) as "Судебные издержки, заявлено",
    		(CAST(b."a4cf970b-b980-4edb-8ad5-ede5fd4a9321" AS numeric)) as "Сумма требований, удовлетворено",
    		(CAST(b."a082a252-859d-4765-90de-b5ad0ab2684c" AS numeric)) as "Основной долг, удовлетворено",
    		(CAST(b."dc9481b9-cf49-4ec5-a402-f88f7b9941bd" AS numeric)) as "Штрафные санкции, удовлетворено",
    		(CAST(b."ea5e0067-e569-4971-a50e-63694ea3e11a" AS numeric)) as "Моральный вред, удовлетворено",
    		(CAST(b."b8308ed7-4ce8-4dec-8ef4-39f7f9264811" AS numeric)) as "Госпошлина, удовлетворено",
    		(CAST(b."6f3e5856-3d94-4e39-ae10-f3c51e9cc9e8" AS numeric)) as "Судебные издержки, удовлетворено",
    		(CAST(b."8526841f-a905-4668-b065-db073bb9d651" AS numeric)) as "Сумма требований, исполнено",
    		(CAST(b."5f468490-42c5-4a46-b9c7-bc5d76b3841f" AS numeric)) as "Основной долг, исполнено",
    		(CAST(b."dd35e552-63f0-4469-a7e1-7a786c30655f" AS numeric)) as "Штрафные санкции, исполнено",
    		(CAST(b."3e5208b3-1353-4cba-8b93-5bdc42f8cd6d" AS numeric)) as "Моральный вред, исполнено",
    		(CAST(b."54c43854-46ef-42e8-bd14-82fdfd9c05e8" AS numeric)) as "Госпошлина, исполнено",
    		(CAST(b."bc5c059b-d212-4f96-a639-c55f5a58a1f0" AS numeric)) as "Судебные издержки, исполнено"		
		FROM "DataBlocks"."Block_7035fe36-4e81-4a3c-85f4-a804e9fdbe00" AS b                                                                                                                                                                 
    	left JOIN "CaseMap"."ProjectVisualBlocks" as pvb ON pvb."Id" = b."ProjectVisualBlockId"                                                                                                                                                                                      
) as SumaZad on SumaZad."ProjectId" = p."Id"  


---------Денежные требования встречный иск-------------
left join (                                                                                                                                                                                                                                 
SELECT                                                                                                                                                                                                                                                                                                                                                                                                                                                         
    		pvb."ProjectId",                                                                                                                                                                                                                
    		(CAST(b."ce452191-1b02-4d19-904e-a1e2f647d206" AS numeric)) as "ВИ Сумма требований, предъявлено",
    		(CAST(b."d595564b-7c3b-4eab-b283-70724fc98200" AS numeric)) as "ВИ Основной долг, предъявлено",
    		(CAST(b."e63a9d73-a1ad-48b6-9f99-326b20fe25c8" AS numeric)) as "ВИ Штрафные санкции, предъявлено",
    		(CAST(b."0e6d3e3a-bb15-424c-a0fa-f0335d53d5cb" AS numeric)) as "ВИ Моральный вред, предъявлено",
    		(CAST(b."7950bc4a-1562-4e06-93e7-4c8b0b691711" AS numeric)) as "ВИ Госпошлина, предъявлено",
    		(CAST(b."7159705f-43d0-4c70-b096-ba65458dd723" AS numeric)) as "ВИ Судебные издержки, предъявлено",
    		(CAST(b."34aeeced-aa2e-40e4-bd72-c1d78fe1a832" AS numeric)) as "ВИ Сумма требований, взыскано судом",
    		(CAST(b."c83793dd-ac1b-49b4-956f-0925d1d01aa9" AS numeric)) as "ВИ Основной долг, взыскано судом",
    		(CAST(b."978d7869-c9b5-4719-84ce-3cb71e65eb7d" AS numeric)) as "ВИ Штрафные санкции, взыскано судом",
    		(CAST(b."99987e50-ebaa-4985-8256-be8b1251f5f0" AS numeric)) as "ВИ Моральный вред, взыскано судом",
    		(CAST(b."af0d5ca7-1c7e-4b95-8e21-2025069aa3cc" AS numeric)) as "ВИ Госпошлина, взыскано судом",
    		(CAST(b."0c5b3889-ffb2-43bb-8b44-5c8654cb9aaa" AS numeric)) as "ВИ Судебные издержки, взыскано судом",
    		(CAST(b."f11dbeec-edc1-42f1-bb96-ff20f60ea540" AS numeric)) as "ВИ Сумма требований, исполнено",
    		(CAST(b."b019d5df-85ff-4f6a-a134-656def318f11" AS numeric)) as "ВИ Основной долг, исполнено",
    		(CAST(b."1469704e-ddf8-4dde-b9bb-e48be22b5a22" AS numeric)) as "ВИ Штрафные санкции, исполнено",
    		(CAST(b."99e74818-c51e-4e67-918b-56e4dd4e4f78" AS numeric)) as "ВИ Моральный вред, исполнено",
    		(CAST(b."b3dc9a89-93fc-457e-9691-a18b38ac5dbf" AS numeric)) as "ВИ Госпошлина, исполнено",
    		(CAST(b."4369347c-7889-46aa-98a7-f1611fb589c8" AS numeric)) as "ВИ Судебные издержки, исполнено"		
		FROM "DataBlocks"."Block_ae6d0bd8-6ef3-4171-8a45-7aea38111bde" AS b                                                                                                                                                                 
    	left JOIN "CaseMap"."ProjectVisualBlocks" as pvb ON pvb."Id" = b."ProjectVisualBlockId"                                                                                                                                                                                      
) as SumaZad2 on SumaZad2."ProjectId" = p."Id"  




left join (
WITH MaxDates AS (
    SELECT 
        pvb."ProjectId",
        MAX(b."f460cfee-5e84-4b27-a6c3-d77d847c301c") AS "MaxDate",
        MAX(pvb."Order") AS "MaxOrder"
    FROM "DataBlocks"."Block_01e546fc-1c1e-467d-9315-4412a367ee59" AS b
    LEFT JOIN "CaseMap"."ProjectVisualBlocks" AS pvb ON pvb."Id" = b."ProjectVisualBlockId"
    GROUP BY pvb."ProjectId"
)
SELECT 
    pvb."ProjectId",
    Courts."Name" as "Суд АС",
    Instance."Name" AS "Инстанция",
    b."f460cfee-5e84-4b27-a6c3-d77d847c301c" as "StartDate"
FROM "DataBlocks"."Block_01e546fc-1c1e-467d-9315-4412a367ee59" AS b
LEFT JOIN "CaseMap"."ProjectVisualBlocks" AS pvb ON pvb."Id" = b."ProjectVisualBlockId"
LEFT JOIN "CaseMap"."Indorsers" AS Instance ON Instance."Id" = b."a946c5eb-2096-4b29-bd61-a1eb7209b4aa"
LEFT JOIN "CaseMap"."Courts" AS Courts ON Courts."Id" = b."f94eb231-f5e3-42ef-b9a3-d076beab7849"
JOIN MaxDates AS md ON md."ProjectId" = pvb."ProjectId" 
WHERE 
(b."f460cfee-5e84-4b27-a6c3-d77d847c301c" IS NULL AND md."MaxOrder" = pvb."Order" and Instance."Name" is not null and Courts."Name" is not null)  
or (b."f460cfee-5e84-4b27-a6c3-d77d847c301c" IS NOT NULL AND md."MaxDate" = b."f460cfee-5e84-4b27-a6c3-d77d847c301c" AND md."MaxOrder" = pvb."Order" and Instance."Name" is not null and Courts."Name" is not null)
ORDER BY pvb."ProjectId" DESC
) as Instance on Instance."ProjectId" = p."Id"

left join (
WITH MaxDates AS (
    SELECT 
        pvb."ProjectId",
        MAX(b."c365e119-f92f-42d4-99e9-b9fcdb034c0c") AS "MaxDate",
        MAX(pvb."Order") AS "MaxOrder"
    FROM "DataBlocks"."Block_b5ced2d1-4ccf-4a05-b649-0f007ca649f7" AS b
    LEFT JOIN "CaseMap"."ProjectVisualBlocks" AS pvb ON pvb."Id" = b."ProjectVisualBlockId"
    GROUP BY pvb."ProjectId"
)
SELECT 
    pvb."ProjectId",
    b."8293625a-1a41-46ed-9f0f-2a9991753797" AS "Суд СОЮ",
    Instance."Name" AS "ИнстанцияСОЮ",
    b."c365e119-f92f-42d4-99e9-b9fcdb034c0c" AS "StartDate"
FROM "DataBlocks"."Block_b5ced2d1-4ccf-4a05-b649-0f007ca649f7" AS b
LEFT JOIN "CaseMap"."ProjectVisualBlocks" AS pvb ON pvb."Id" = b."ProjectVisualBlockId"
LEFT JOIN "CaseMap"."Indorsers" AS Instance ON Instance."Id" = b."99713062-7b66-4bd9-a89f-39671e864d69"
JOIN MaxDates AS md ON md."ProjectId" = pvb."ProjectId" 
WHERE 
(b."c365e119-f92f-42d4-99e9-b9fcdb034c0c" IS NULL AND md."MaxOrder" = pvb."Order" and Instance."Name" is not null and b."8293625a-1a41-46ed-9f0f-2a9991753797" is not null)  
or (b."c365e119-f92f-42d4-99e9-b9fcdb034c0c" IS NOT NULL AND md."MaxDate" = b."c365e119-f92f-42d4-99e9-b9fcdb034c0c" AND md."MaxOrder" = pvb."Order" and Instance."Name" is not null and b."8293625a-1a41-46ed-9f0f-2a9991753797" is not null)
ORDER BY pvb."ProjectId" DESC
) as InstanceSOU on InstanceSOU."ProjectId" = p."Id"

left join (
		SELECT
		    pvb."ProjectId",
		    b."b4813400-fe09-4a97-898c-36f578c78324" as "Экономический эффект по встречному иску"
		from "DataBlocks"."Block_b76755f5-41c1-4913-a8e4-4b0f4a6f90ee" AS b
		LEFT JOIN "CaseMap"."ProjectVisualBlocks" AS pvb ON pvb."Id" = b."ProjectVisualBlockId"
) as EcoEffVIsk on EcoEffVIsk."ProjectId" = p."Id"




where p."ProjectTypeId"='8ec7f7bd-a093-4398-b0f1-e7ebfb2b4fc9' and status."Стадия" != 'Черновик' and  p."IsArchive" = false and p."IsDeleted" = false and ({condition:c10}) and ({condition:c55}) and ({condition:c56}) and ({condition:c57})  --and p."Id" in ('f1cc4a7c-9789-2016-e517-b1410073bd17', '7b9c0834-f431-b4b5-76a6-b147012ef66e') 


) ab2;





select 
		ROW_NUMBER() OVER(ORDER BY ab2."Дата возникновения спора") AS row_number,
		to_char(ab2."Дата возникновения спора",'DD.MM.YYYY'),
		to_char(ab."Дата заседания",'DD.MM.YYYY HH24:MI'),
		ab2."№ дела",
		to_char(ab2."Дата завершения спора",'DD.MM.YYYY'),
		ab2."Орган",
		ab2."Имя истца" as "Истец",
		ab2."Имя ответчика" as "Ответчик",
		ab2."Имя третье лицо" as "Третье лицо",
		ab2."Компания Группы",
		ab2."Привлеченный консультант" as "Юр. компании",
		ab2."Вероятность решения спора в пользу Компании Группы" as "Вероятность решения спора в пользу Компании Группы",
		ab2."Категория спора" as "Категория",
		ab2."Вид спора" as "Вид",
		ab2."Характер спора" as "Характер",
		ROUND(ab2."Сумма требований, заявлено",2) as "Сумма требований, заявлено",
	    ROUND(ab2."Основной долг, заявлено",2) as "Основной долг, заявлено",
	    ROUND(ab2."Штрафные санкции, заявлено",2) as "Штрафные санкции, заявлено",
	    ROUND(ab2."Моральный вред, заявлено",2) as "Моральный вред, заявлено",
	    ROUND(ab2."Госпошлина, заявлено",2) as "Госпошлина, заявлено",
	    ROUND(ab2."Судебные издержки, заявлено",2) as "Судебные издержки, заявлено",
	    ROUND(ab2."Сумма требований, удовлетворено",2) as "Сумма требований, удовлетворено",
	    ROUND(ab2."Основной долг, удовлетворено",2) as "Основной долг, удовлетворено",
	    ROUND(ab2."Штрафные санкции, удовлетворено",2) as "Штрафные санкции, удовлетворено",
	    ROUND(ab2."Моральный вред, удовлетворено",2) as "Моральный вред, удовлетворено",
	    ROUND(ab2."Госпошлина, удовлетворено",2) as "Госпошлина, удовлетворено",
	    ROUND(ab2."Судебные издержки, удовлетворено",2) as "Судебные издержки, удовлетворено",
	    ROUND(ab2."Сумма требований, исполнено",2) as "Сумма требований, исполнено",
	    ROUND(ab2."Основной долг, исполнено",2) as "Основной долг, исполнено",
	    ROUND(ab2."Штрафные санкции, исполнено",2) as "Штрафные санкции, исполнено",
	    ROUND(ab2."Моральный вред, исполнено",2) as "Моральный вред, исполнено",
	    ROUND(ab2."Госпошлина, исполнено",2) as "Госпошлина, исполнено",
	    ROUND(ab2."Судебные издержки, исполнено",2) as "Судебные издержки, исполнено",	
	    ROUND(ab2."ВИ Сумма требований, предъявлено",2) as "ВИ Сумма требований, предъявлено",
	    ROUND(ab2."ВИ Основной долг, предъявлено",2) as "ВИ Основной долг, предъявлено",
	    ROUND(ab2."ВИ Штрафные санкции, предъявлено",2) as "ВИ Штрафные санкции, предъявлено",
	    ROUND(ab2."ВИ Моральный вред, предъявлено",2) as "ВИ Моральный вред, предъявлено",
	    ROUND(ab2."ВИ Госпошлина, предъявлено",2) as "ВИ Госпошлина, предъявлено",
	    ROUND(ab2."ВИ Судебные издержки, предъявлено",2) as "ВИ Судебные издержки, предъявлено",
	    ROUND(ab2."ВИ Сумма требований, взыскано судом",2) as "ВИ Сумма требований, взыскано судом",
	    ROUND(ab2."ВИ Основной долг, взыскано судом",2) as "ВИ Основной долг, взыскано судом",
	    ROUND(ab2."ВИ Штрафные санкции, взыскано судом",2) as "ВИ Штрафные санкции, взыскано судом",
	    ROUND(ab2."ВИ Моральный вред, взыскано судом",2) as "ВИ Моральный вред, взыскано судом",
	    ROUND(ab2."ВИ Госпошлина, взыскано судом",2) as "ВИ Госпошлина, взыскано судом",
	    ROUND(ab2."ВИ Судебные издержки, взыскано судом",2) as "ВИ Судебные издержки, взыскано судом",
	    ROUND(ab2."ВИ Сумма требований, исполнено",2) as "ВИ Сумма требований, исполнено",
	    ROUND(ab2."ВИ Основной долг, исполнено",2) as "ВИ Основной долг, исполнено",
	    ROUND(ab2."ВИ Штрафные санкции, исполнено",2) as "ВИ Штрафные санкции, исполнено",
	    ROUND(ab2."ВИ Моральный вред, исполнено",2) as "ВИ Моральный вред, исполнено",
	    ROUND(ab2."ВИ Госпошлина, исполнено",2) as "ВИ Госпошлина, исполнено",
	    ROUND(ab2."ВИ Судебные издержки, исполнено",2) as "ВИ Судебные издержки, исполнено",
		ab2."Ответственный юрист",
		ab2."Статус",
 		ab2."Инстанция",
		ab2."Встречный иск",
		ROUND(ab2."Экономический эффект общий",2) as "Экономический эффект",	
		ab2."Результат",
		ab2."Номер дела",
		ab2."Id",
		ab2."Вид суда"
		
		
from temptable ab
join tempTable2 as ab2 on ab2."Id" = ab."Id"
where 
({condition:c1}) 	
and ({condition:c2})
and ({condition:c3})
and ({condition:c4})
and ({condition:c8})
and ({condition:c9})
and ({condition:c11})
and ({condition:c12})
and ({condition:c13})
and ({condition:c14})
and ({condition:c15})
and ({condition:c16})
and ({condition:c17})
and ({condition:c18})
and ({condition:c19})
and ({condition:c20})
and ({condition:c21})
and ({condition:c22})
and ({condition:c23})
and ({condition:c24})
and ({condition:c25})
and ({condition:c26})
and ({condition:c27})
and ({condition:c28})
and ({condition:c29})
and ({condition:c30})
and ({condition:c31})
and ({condition:c32})
and ({condition:c33})
and ({condition:c34})
and ({condition:c35})
and ({condition:c36})
and ({condition:c37})
and ({condition:c38})
and ({condition:c39})
and ({condition:c40})
and ({condition:c41})
and ({condition:c42})
and ({condition:c43})
and ({condition:c44})
and ({condition:c45})
and ({condition:c46})
and ({condition:c47})
and ({condition:c48})
and ({condition:c49})
and ({condition:c50})
and ({condition:c51})
and ({condition:c52})
and ({condition:c53})
and ({condition:c54})

;
drop table if exists temptable,temptable2 ;