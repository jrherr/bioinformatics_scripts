USE shig_MLST7;
SELECT 
	strainst.strainname,
	aspC.sequence AS aspC,
	clpX.sequence AS clpX,
	fadD.sequence AS fadD,
	icdA.sequence AS icdA,
	lysP.sequence AS lysP,
	mdh.sequence  AS mdh,
	uidA.sequence AS uidA
FROM strainst
LEFT JOIN aspC ON strainst.aspC=aspC.id
LEFT JOIN clpX ON strainst.clpX=clpX.id
LEFT JOIN fadD ON strainst.fadD=fadD.id
LEFT JOIN icdA ON strainst.icdA=icdA.id
LEFT JOIN lysP ON strainst.lysP=lysP.id
LEFT JOIN mdh  ON strainst.mdh=mdh.id
LEFT JOIN uidA ON strainst.uidA=uidA.id;
