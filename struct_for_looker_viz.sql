with fb as (
	select 
		f.ad_date,
		f.url_parameters,
		sum(f.spend) as spend, 
		sum(f.impressions) as impressions, 
		sum(f.reach) as reach, 
		sum(f.clicks) as clicks, 
		sum(f.leads) as leads, 
		sum(f.value) as value 
	from facebook_ads_basic_daily f
	left join public.facebook_campaign c on f.campaign_id = c.campaign_id
	left join public.facebook_adset a on f.adset_id = a.adset_id
	where f.ad_date is not null
	group by f.ad_date,
	         c.campaign_name,
		     a.adset_name
),
fplusg as (
	select 
		'Facebook Ads' as media_source,
		*
	from fb 
	union all
	select
		'Google Ads' as media_source,
		g.ad_date,
		g.url_parameters,
		sum(g.spend) as spend, 
		sum(g.impressions) as impressions, 
		sum(g.reach) as reach, 
		sum(g.clicks) as clicks, 
		sum(g.leads) as leads, 
		sum(g.value) as value 
	from google_ads_basic_daily g
	group by media_source,
			 ad_date,
			 campaign_name,
			 adset_name
)
select 
	*
from fplusg group by ad_date,
;
