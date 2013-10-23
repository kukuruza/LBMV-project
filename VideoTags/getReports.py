import requests
from bs4 import BeautifulSoup
import pdb
import re
import operator

def getGameInfo(page_url):
	bbc_page=requests.get(page_url).text
	bbc_page= BeautifulSoup(bbc_page)
	date=getDate(bbc_page)
	teams=getTeamNames(bbc_page)
	times,events=getTimesAndEvents(bbc_page)
	return(date,teams,times,events)

def getDate(bbc_page):
	spans=bbc_page.find_all('span');
	spans=[span for span in spans if span.get('class')]
	date=[span.text for span in spans if span.get('class')[0]=='date']
	return date
	
def getTeamNames(bbc_page):
	spans=bbc_page.find_all('span');
	spans=[span for span in spans if span.get('class')]
	team_names=[span.text for span in spans if span.get('class')[0]=='team-name']
	return team_names
	
def getTimesAndEvents(bbc_page):
	spans=bbc_page.find_all('span');
	classes=[]
	for span_curr in spans:
		if span_curr.get('class'):
			for class_curr in span_curr.get('class'):
				if class_curr.find('icon-live-text')!=-1:
					classes.append(class_curr)

	span_rel=[]
	_dig=re.compile('\d')
	_alpha=re.compile('[a-z,A-Z]')
	for span_curr in spans:
		if span_curr.get('class'):
			if len(set(span_curr.get('class')).intersection(set(classes)))>0:
					if bool(_dig.search(span_curr.parent.text)):
						span_rel.append(span_curr.parent)
					else:
						span_rel.append(span_curr.parent.parent)

	times=[curr_tag.text[:_alpha.search(curr_tag.text).start()] for curr_tag in span_rel]
	events=[curr_tag.text[_alpha.search(curr_tag.text).start():] for curr_tag in span_rel]
	return (times,events)

	

page_url='http://www.bbc.co.uk/sport/football/premier-league/results'
url_pre='http://www.bbc.co.uk/'
bbc_page=requests.get(page_url).text
bbc_page= BeautifulSoup(bbc_page)
spans=bbc_page.find_all('a');
spans=[span_curr for span_curr in spans if span_curr.get('class')]
urls=[span_curr.get('href') for span_curr in spans if span_curr.get('class')[0]=='report']

urls=[operator.concat(url_pre,url) for url in urls]

for page_url in urls:
	date,team,time,event=getGameInfo(page_url)
	file_str=team[0]+'_'+team[1]+'_'+date[0]+'.txt'
	with open(file_str, 'w') as f:
		for time_curr in time:
			f.write(time_curr+'\t')
		f.write('\n')
		for event_curr in event:
			f.write(event_curr+'\t')
		f.close()


pdb.set_trace()
