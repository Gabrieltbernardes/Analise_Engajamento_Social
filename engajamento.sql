-- Criação do Banco de Dados
CREATE database engajamento;

-- Garantindo o uso do banco de dados 
USE engajamento;

-- Criação da tabela que contem as informações principais
CREATE TABLE posts (
    post_id VARCHAR(50) PRIMARY KEY,
    timestamp DATETIME,
    day_of_week VARCHAR(20),
    platform VARCHAR(50),
    user_id VARCHAR(50),
    location VARCHAR(100),
    language VARCHAR(50),
    text_content TEXT, 
    hashtags TEXT, 
    topic_category VARCHAR(100),
    sentiment_score DECIMAL(10, 4), 
    sentiment_label VARCHAR(20),
    emotion_type VARCHAR(50),
    toxicity_score DECIMAL(10, 4), 
    likes_count INT,
    shares_count INT, 
    comments_count INT, 
    impressions INT,
    brand_name VARCHAR(100)
);

-- Importação do Banco de Dados
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Social_Dataset.csv'
INTO TABLE posts
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
-- Mapeamento de todas as variáveis a serem usadas
(post_id,timestamp,day_of_week,platform,user_id,location,language,text_content,hashtags,
@ignorar_mentions,@ignorar_keywords, topic_category, sentiment_score, sentiment_label,
emotion_type, toxicity_score, likes_count, shares_count, comments_count,
impressions, @ignorar_engagement_rate, brand_name, @ignorar_product_name, @ignorar_campaign_name,
@ignorar_campaign_phase, @ignorar_user_past_sentiment_avg, @ignorar_user_engagement_growth,
@ignorar_buzz_change_rate);


-- 1. Tabela que responde a pergunta "Qual plataforma possui a melhor taxa de engajamento REAL?"
CREATE TABLE eficiencia_real_plataforma AS
SELECT
    platform AS plataforma,
    SUM(impressions) AS total_impressoes,
    (SUM(likes_count + (comments_count * 2) + (shares_count * 3)) * 100.0 / SUM(impressions)) AS taxa_engajamento_real,
    (SUM(likes_count + (comments_count * 2) + (shares_count * 3))) AS engajamento_real
FROM
    posts
WHERE
    impressions > 0
GROUP BY
    platform
ORDER BY
    taxa_engajamento_real DESC;


-- 2. Tabela que responde a pergunta "Em qual dia da semana cada marca inspira mais INTERAÇÃO?"
CREATE TABLE melhor_dia_interacao_por_marca AS
WITH EngajamentoDiario AS (
    SELECT
        brand_name AS marca,
        day_of_week AS dia_da_semana,
        AVG(likes_count + (comments_count * 2) + (shares_count * 3)) AS media_score_engajamento,
        ROW_NUMBER() OVER(PARTITION BY brand_name ORDER BY AVG(likes_count + (comments_count * 2) + (shares_count * 3)) DESC) as ranking_dia
    FROM
        posts
    WHERE
        brand_name IS NOT NULL AND brand_name != ''
    GROUP BY
        brand_name, day_of_week
)
SELECT
    marca,
    dia_da_semana,
    media_score_engajamento
FROM
    EngajamentoDiario
WHERE
    ranking_dia = 1
ORDER BY
    media_score_engajamento DESC;

-- 3. Tabela que responde a pergunta "Qual é a emoção predominante nas experiências MAIS NEGATIVAS dos clientes?"
CREATE TABLE emocao_critica_por_topico AS
SELECT
    topic_category AS categoria_do_topico,
    emotion_type AS emocao_predominante,
    COUNT(*) AS quantidade_de_posts,
    AVG(sentiment_score) AS media_score_negativo
FROM
    posts
WHERE
    topic_category = 'Delivery' AND sentiment_score < -0.6 
GROUP BY
    topic_category, emotion_type
ORDER BY
    categoria_do_topico, quantidade_de_posts DESC;


-- 4. Tabela que responde a pergunta "Qual a evolução semanal da SAÚDE das marcas (sentimento e toxicidade)?"
CREATE TABLE saude_semanal_marca AS
SELECT
    YEARWEEK(timestamp, 1) AS ano_semana,
    AVG(sentiment_score) AS media_score_sentimento, 
    AVG(toxicity_score) AS media_score_toxicidade,
    COUNT(*) AS total_de_posts
FROM
    posts
WHERE
    brand_name = 'Microsoft'
GROUP BY
    ano_semana
ORDER BY
    ano_semana;

-- 5. Tabela que responde a pergunta "Qual marca domina a conversa em termos de sentimento, segurança e engajamento?"
-- Com base na Taxa de Engajamento Ponderada : Stieglitz, S., Dang-Xuan, L. (2013) – Social media and political communication: a social media analytics framework
CREATE TABLE comparativo_google_vs_microsoft AS
WITH TopicosComuns AS (
    SELECT topic_category 
    FROM posts 
    WHERE brand_name IN ('Google', 'Microsoft')
    GROUP BY topic_category 
    HAVING COUNT(DISTINCT brand_name) = 2
)
SELECT
	p.brand_name AS marca,
    p.topic_category AS topico_em_comum,
    AVG(p.sentiment_score) AS media_sentimento,
    AVG(p.toxicity_score) AS media_toxicidade,
    (SUM(p.likes_count + (p.comments_count * 2) + (p.shares_count * 3))  / SUM(p.impressions)) AS taxa_engajamento_real
FROM
    posts p
JOIN
    TopicosComuns tc ON p.topic_category = tc.topic_category
WHERE
    p.brand_name IN ('Google', 'Microsoft') AND p.impressions > 0
GROUP BY
    p.topic_category, p.brand_name
ORDER BY
    topico_em_comum, media_sentimento DESC;


-- 6. Tabela que responde a pergunta "Onde estão os "focos de incêndio" geográficos?"
-- com base na intensidade do sentimento negativo e da toxicidade
CREATE TABLE focos_crise_intensidade_geografica AS
SELECT
    location,
    AVG(sentiment_score) AS media_sentimento,
    AVG(toxicity_score) AS media_toxicidade,
    COUNT(*) AS numero_de_posts
FROM
    posts
WHERE
    topic_category = 'Product'
GROUP BY
    location, topic_category
HAVING
    COUNT(*) > 5 AND media_sentimento < 0 AND media_toxicidade > 0.5
ORDER BY
    media_sentimento;