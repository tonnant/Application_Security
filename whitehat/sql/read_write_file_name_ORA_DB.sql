select v$datafile.name "File Name", v$filestat.phyrds "Reads", v$filestat.phywrts "Writes" from v$filestat,v$datafile where v$filestat.file# = v$datafile.file#;
