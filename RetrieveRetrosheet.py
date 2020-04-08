import requests
import os
import pyodbc
from os import path
import zipfile
from shutil import copyfile
from datetime import datetime
import csv


class Retrosheet():
    
    def __init__(self):
        self.now = datetime.now()
        self.log = 'C:\\retro\\ProcessLog\\log_{}{}{}.txt'.format(self.now.year, self.now.month, self.now.day)
        self.directories = []

    def get_file(self,startyear, endyear, file_type, inc):
        
        self.directories = []
                      
        if path.exists(self.log):
            logfile = open(self.log, 'a')
            logfile.write('\n\n Processing Bevent as of: {}{}{}'.format(self.now.year, self.now.month, self.now.day))
        else:
            logfile = open(self.log, 'w')
            logfile.write('New file started:\n\nProcessing Bevent as of: {}{}{}'.format(self.now.year, self.now.month, self.now.day))
        
        numerrors = 0
        goodFile = True
        
        if file_type == 'reg':
            tag = 'eve.zip'
        elif file_type == 'post':
            tag = 'post.zip'
        elif file_type == 'decade':
            tag =  'seve.zip'
        else:
            goodFile = False
        
        if goodFile:
        
            for y in range(startyear, endyear + 1, inc):
                error = 0
                
                src = 'C:\\retro\\RawFiles'
                
                if not path.exists(src[:8]):
                    os.mkdir(src[:8])
                
                if not path.exists(src):
                    os.mkdir(src)
                
                url = "https://www.retrosheet.org/events/{}{}".format(y, tag)
                directory_to_extract_to = 'C:\\retro\\RawFiles\\{}_{}'.format(y, file_type)
                
                if file_type == 'reg':
                    filepath = 'C:\\retro\\RawFiles\\{}'.format(url[-11:])
                else:
                    filepath = 'C:\\retro\\RawFiles\\{}'.format(url[-12:])
                    
                if not path.exists(filepath):
                    
                    r = requests.get(url)
                    
                    try:
                        r.raise_for_status()
                    except Exception as exc:
                        error = 1
                        numerrors += 1
                        logfile.write('\n\nThere was a problem: {}'.format(exc))
                    
                    if error == 0:
                        with open(filepath, 'wb') as f:
                            f.write(r.content)
                        
                        logfile.write('\n\nSuccessfully downloaded {}'.format(filepath))
                        
                        if not path.exists(directory_to_extract_to):
                            
                            os.mkdir(directory_to_extract_to)
                            
                            with zipfile.ZipFile(filepath, 'r') as zip_ref:
                                zip_ref.extractall(directory_to_extract_to)
                                
                            copyfile('C:\\Users\\Taylor.Douglas\\Documents\\retro\\RawFiles\\BEVENT.exe', 
                                            path.join(directory_to_extract_to, 'BEVENT.exe'))
                        
                        else:
                            logfile.write('\n\n{} not unzipped'.format(filepath))
                        
                else:
                        logfile.write('\n\n{} is already downloaded'.format(filepath))
                
                self.directories.append(directory_to_extract_to)
                
                if numerrors >= 3:
                    logfile.write('\n\nError limit of 3 exceeded. Process terminated')
                    break
        
        logfile.close()
        
    def run_bevent_tocsv(self, fieldlist = [[0,96]]):
        
        directories = self.directories
        
        if path.exists(self.log):
            logfile = open(self.log, 'a')
            logfile.write('\n\n Processing Bevent as of: {}{}{}'.format(self.now.year, self.now.month, self.now.day))
        else:
            logfile = open(self.log, 'w')
            logfile.write('New file started:\n\nProcessing Bevent as of: {}{}{}'.format(self.now.year, self.now.month, self.now.day))
        
        
        fields = ''
    
        i = 0
        
        if type(fieldlist) == list:
            for field in fieldlist:
                if i == 0:
                    if type(field) == list and len(field) > 1:
                        fields = '-f ' + fields + str(field[0]) + '-' + str(field[1])
                    elif type(field) == list and len(field) == 1:
                        fields = '-f ' + fields + str(field[0])
                    else:
                        fields = '-f ' + fields + str(field)
                if i >= 1:
                    if type(field) == list and len(field) > 1:
                        fields = '{}, {}-{}'.format(fields, field[0], field[1])
                    elif type(field) == list and len(field) == 1:
                        fields = '{}, {}'.format(fields, field)
                    else:
                        fields = '{}, {}'.format(fields, field)
                
                i += 1
        
        elif type(fieldlist) == int:
            fields = '-f ' + str(fieldlist)        
                    
        for d in directories:
        
            os.chdir(d)
            
            landing = 'C:\\retro\\RawFiles\\csvs'
            
            if not path.exists(landing):
                os.mkdir(landing)
        
            for (dirname, dirs, files) in os.walk(d):
                for filename in files:
                    if filename[-3:] == 'EVA' or filename[-3:] == 'EVN' or filename[-3:] == 'EVE':
                    #if filename[0:4] == '2010' and filename[-3:] == 'EVA':
                        
                        if d[-4:] == 'post':
                            csvfile = filename[0:7] + '_post.csv'
                        else:
                            csvfile = filename[0:7] + '.csv'
                        
                        year = filename[0:4]
                        if not path.exists(path.join(landing, csvfile)):
                            cmd = 'bevent -y {} {} {} >{}'.format(year, fields, filename, path.join(landing, csvfile))
                            os.system(cmd)
                            logfile.write('\n\nExecuted {} for {}.'.format(cmd, filename))
                            #print('Executed ' + cmd + ' for ' + filename)
                        #cmd = 'bevent -y ' + year + ' -f 0-96 ' + filename + ' >FileOutput\\' + thefile + '.csv'
                        #print(thefile)
                        else:
                            logfile.write('\n\n{} already exists.'.format(csvfile))
        
        logfile.close()
        
    def get_single(self, startyear, endyear = None, season_part = 'reg'):
        
        """ name: get_single
            desc: Iterates through a range of years and pulls associated Single Year Files from Retrosheet
            params: startyear -- an integer year
                    endyear -- an integer year > startyear. If endyear < startyear, it is automatically set
                                to the startyear value
                    season_part -- 'reg' for regular season
                                   'post' for postseason
                                   
                    *Note: Postseason files are only for single seasons
        """
        try:
                   
            if not endyear:
                endyear = startyear
            
            if endyear < startyear:
                endyear = startyear
            
            startyear = int(startyear)
            endyear = int(endyear)
            
            inc = 1
            
            self.get_file(startyear, endyear, season_part, inc)
            
        except ValueError as val:
            print('startyear and endyear should be integer values') 
            
    def get_decade(self, startyear, endyear = None):
        
        """ name: get_decade
            desc: Iterates through a range of decades and pulls associated Decade Files from Retrosheet
            params: startyear -- an integer year
                    endyear -- an integer year > startyear. If endyear < startyear, it is automatically set
                                to the startyear value
                                
                    *Note: Decade files only contain regular season data
        """
        
        try:
            
            startyear = int(startyear)
            endyear = int(endyear)
            
            if endyear < startyear:
                endyear = startyear
            
            startyear = startyear - int(str(startyear)[-1])
            
            if endyear:
                endyear = endyear - int(str(endyear)[-1])
            else:
                endyear = startyear
            
            file_type = 'decade'
            inc = 10
            
            self.get_file(startyear, endyear, file_type, inc)
                    
        except ValueError as val:
            print('startyear and endyear should be integer values')

    def single_tocsv(self, startyear, endyear = None, season_part = 'reg', fieldlist = [[0,96]]):
        
        self.get_single(startyear, endyear, season_part)
        
        self.run_bevent_tocsv(fieldlist)
        
    def decade_tocsv(self, startyear, endyear = None, fieldlist = [[0,96]]):
        
        self.get_decade(startyear, endyear)
        
        self.run_bevent_tocsv(fieldlist)

###########################################
######RetroSQL Class#######################
#Performs SQL Operations for Retrosheet DB#
###########################################

class RetroSQL():
    
    def __init__(self):
        self.now = datetime.now()
        
#Super Buggy
    def create_connection(self, driver, server, db, tc = 'yes'):
        self.conn = pyodbc.connect("""Driver={};
                          Server={};
                          Database={};
                          Trusted_Connection={};""".format(driver,server,db,tc))
        
        self.cursor = self.conn.cursor()
        self.datab = db 
    
    def close_connection(self):
        self.conn.close()
    
    def open_logfile(self, logpath = 'C:\\retro\\ProcessLog'):
        
        logfile = open(path.join(logpath,'log_{}{}{}.txt'.format(self.now.year, self.now.month, self.now.day)), 'a')
        
        try:
            logfile.write('\n\nStarting Additional Processing as of {}.\n\n'.format(self.now))
        except OSError:
            logfile = open(path.join(logpath,'log_{}{}{}.txt'.format(self.now.year, self.now.month, self.now.day)), 'w')
            logfile.write('Starting new file as of {}\n\n'.format(self.now))
           
        return logfile
    
    def import_play(self, startyear, endyear = None, playpath = 'C:\\retro\\RawFiles\\csvs'):
            
        if isinstance(startyear, int):
            
            if not isinstance(endyear, int):
                endyear = startyear
                
            if endyear < startyear:
                endyear = startyear
            
            logfile = self.open_logfile()
            
            for (dirname, dirs, files) in os.walk(playpath):
                i = 1
                oldcount = int(self.cursor.execute('Select Count(*) From stage.PlayByPlay').fetchval())
                for filename in files:
                    
                    f = path.join(playpath, filename)
                    
                    if int(filename[0:4]) >= startyear and int(filename[0:4]) <= endyear:
                        
                        sqlcmd = '''Bulk insert stage.PlayByPlay
                                    From ''' + '\'' + f + '\'' + \
                                    '''\nWITH
                                    (
                                    Firstrow = 1,
                                    FieldTerminator = ',',
                                    RowTerminator = '\n',
                                    Format = 'CSV'
                                    )'''
                        logfile.write('\n\nProcessing: {}'.format(f))
                        #print(sqlcmd)
                        try:
                            self.cursor.execute(sqlcmd)
                            self.cursor.commit()
                            success = 1
                        except: 
                            logfile.write('\n\nERROR--Could not execute: {}\n\n'.format(sqlcmd))
                            success = 0
                        
                        newcount = int(self.cursor.execute('Select Count(*) From stage.PlayByPlay').fetchval())
                        diff = newcount-oldcount
                        logcmd = """Insert Into ETL_Processing.dbo.FileImport 
                                    (ImportedFile, RowsInserted, InsertTime, DestTable, IsSuccessful, db) 
                                    \nValues('{}', {}, GetDate(), 'stage.PlayByPlay', '{}', '{}')""".format(f, diff, success, self.datab)
                        #+ f + '\', ' + str(diff) + ', GetDate())'
                        logfile.write('\n\n{}'.format(logcmd))
                        self.cursor.execute(logcmd)
                        self.cursor.commit()
                        logfile.write('\n\nRows inserted into stage.PlayByPlay: {}'.format(str(diff)))
                        logfile.write('\n\nDone with file: {}'.format(f))
                        
                        oldcount += diff
                        i +=1
                    
                    else:
                        logfile.write('\n\nSkipped: {}\n\tNo rows were processed'.format(f))
                            
            logfile.close()
        else:
            print('Startyear must be an integer value')
            
    def insert_stagepitch(self):
           
        seq = self.cursor.execute('exec get_pitchsequence').fetchall()
        
        i = 0
          
        logfile = self.open_logfile('C:\\retro\\ProcessLog')
        
        for g, e, s in seq:
            a = 1
            for p in s:
                #print(g, e, a, p)
                cmd = "Insert into stage.PitchByPitch Values ('{}', {}, {}, '{}')".format(g, e, a, p)
                
                try:
                    self.cursor.execute(cmd)
                    self.cursor.commit()
                except:
                    logfile.write('Could not execute {}\n\n'.format(cmd))
                    
                a +=1
            
            i += 1
            if i >= 50000:
                if i % 50000 == 0:
                    logfile.write('{} rows processed'.format(i))
                
        logfile.close()
        
    def action_tocsv(self, startyear, endyear = None):
        
        if isinstance(startyear, int):
            
            if not isinstance(endyear, int):
                endyear = startyear
                
            if endyear < startyear:
                endyear = startyear
                
            logfile = self.open_logfile('C:\\retro\\ProcessLog')
    
            teams = self.cursor.execute("""Select Distinct teamidretro, YearID 
                                        from stage.Team 
                                        where yearid between {} and {}""".format(startyear, endyear)).fetchall()
            
            landing = 'C:\\retro\\RawFiles\\Actions'
            
            if not path.exists(landing[0:8]):
                os.mkdir(landing[0:8])
                
            if not path.exists(landing[0:17]):
                os.mkdir(landing[0:17])
                
            if not path.exists(landing):
                os.mkdir(landing)
                
            i = 1
            
            for t, y in teams:
                #print(t,y)
                #print(t[0])
                
                if not path.exists(path.join(landing, '{}_{}.csv'.format(t,y))):
                    csvfile = path.join(landing, '{}_{}.csv'.format(t,y))
                    
                    seq = self.cursor.execute(
                    """SELECT pbp.[GameId]
                            ,pbp.[EventNum]
                            ,[SequenceNumber]
                            ,[Pitch]
                            , pt.*
                            , maxseq
                    FROM [Retrosheet].[stage].[PitchByPitch] pbp
                    join stage.PitchType pt
                        on pbp.pitch = pt.PitchCode
                    join (select Max(sequencenumber) maxseq, Gameid, eventnum from stage.PitchByPitch group by gameid, eventnum) maxs
                        on pbp.GameId = maxs.GameId
                        and pbp.EventNum = maxs.EventNum
                    where left(pbp.GameId,3) = \'{}\'
                    and cast(substring(gameid, 4, 4) as int) = {}
                    order by pbp.GameId, EventNum""".format(t, y)).fetchall()      
                    
                    with open(csvfile, 'w', newline = '') as writeFile:
                        writer = csv.writer(writeFile)
                        
                        for row in seq:
                            gameid = row[0]
                            event = row[1]
                            action = row[2]
                            pitchtype = row[3]
                            isPitch = row[6]
                            isStrike = row[7]
                            isBall = row[8]
                            foul = row[13]
                            foulTip = row[14]
                            maxseq = row[20]
                            
                            if action == 1:
                                strikes = 0
                                balls = 0
                            
                            currentBalls = balls
                            currentStrikes = strikes
                            
                            if isBall == 1:
                                balls += 1
                            
                            if isStrike == 1:
                                strikes += 1
                            
                            if foul == 1 and strikes > 2:
                                strikes -= 1
                            
                            if pitchtype == 'L' and currentStrikes == 2:
                                strikes += 1
                            
                            if foulTip == 1 and currentStrikes == 2 and pitchnum == maxseq:
                                strikes += 1
                                         
                            if pitchnum == maxseq:
                                isFinal = 1
                            else:
                                isFinal = 0
                            
                            lines = [gameid, event, action, pitchtype, currentBalls, currentStrikes, None, None, None, None
                                    , balls, strikes, isFinal, None, None, None]
                            
                            
                            writer.writerow(lines)
                        
                    writeFile.close()
                    logfile.write('\n\nProcessed team: {}  year: '.format(t,y))
                    i+=1
            
            logfile.close()
                                         
        else:
            print('startyear must be an integer')
            
    def insert_work_action(self, actionpath):
                
        if path.exists(actionpath):
            
            logfile = self.open_logfile()
    
            for (dirname, dirs, files) in os.walk(actionpath):
                i = 1
                oldcount = int(self.cursor.execute('Select Count(*) From work.ActionByCount').fetchval())
                for filename in files:
                    f = path.join(actionpath, filename)
                    sqlcmd = '''Bulk insert work.ActionByCount
                                From ''' + '\'' + f + '\'' + \
                                '''\nWITH
                                (
                                Firstrow = 1,
                                FieldTerminator = ',',
                                RowTerminator = '\n',
                                Format = 'CSV'
                                )'''
                    logfile.write('\n\nProcessing ' + f)
                    #print(sqlcmd)
                    try:
                        self.cursor.execute(sqlcmd)
                        self.cursor.commit()
                        success = 1
                    except:
                        logfile.write('Could not process {}'.format(f))
                        success = 0
                    newcount = int(self.cursor.execute('Select Count(*) From work.ActionByCount').fetchval())
                    diff = newcount-oldcount
                    logcmd = """Insert Into ETL_Processing.dbo.FileImport 
                             (ImportedFile, RowsInserted, InsertTime, DestTable, IsSuccessful, db) 
                             \nValues('{}', {}, GetDate(), 'work.ActionByCount', '{}', '{}')""".format(f, diff, success, self.datab)
                    
                    self.cursor.execute(logcmd)
                    self.cursor.commit()
                    
                    logfile.write('\n\nDone with file: ' + f)
                    logfile.write('\n\tRows inserted into work.ActionByCount ' + str(diff))
                    oldcount += diff
                    i +=1
                    
            logfile.close()
        else:
            print('{} does not exist.'.format(actionpath))






