/*
 REFERENCED FROM THE BIORYTHM FOR ANDROID

 */


#include "mvnpdf.h"


int i,j;
double xMinusMu[3], nom,expNom;
char s[32];
//double d = 0.5;

double computeMvnPdf(double *x,double *mean, double invCov[][3], double denom)
{

	nom = 0;

	//x minus mean
	for(i=0;i<3;i++)
		xMinusMu[i] = x[i] - mean[i];

	//compute the nominator
	for(i=0;i<3;i++)
		for(j=0;j<3;j++)
			nom = nom - invCov[i][j] * xMinusMu[i] * xMinusMu[j];

	return 0.5*nom - denom;

	//return 0;

}
