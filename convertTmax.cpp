#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <iostream>
#include <iomanip>
#include <fstream>
#include <sstream>
#include <ctime>
#include <string.h>
using namespace std;

bool processData(string, int, int, string, string, string);
void writeRecord(string, int);
void writeMissingMonth(int);
int ymd2day(int, int, int);
int str2int(string str);
double str2double(string str);

int days_in_month[13] = { 0, 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 };
int NO_DATA = -99;
FILE *infFile;
FILE *out;

int tokenize(string str, string *arr) {

    char *cstr = new char[str.length() + 1];
    strcpy(cstr, str.c_str());
    char *part = strtok(cstr, ",");
    int i = 0;
    
    while (part != 0) {
     stringstream ss;
     ss << part;
     *(arr + i) = ss.str();
     part = strtok(NULL, ",");
     i++;
    }
    return i;
}

int main(int argc, char *argv[]) {

	string COUNTRY;
	string STATE;
	string VARIABLE;
	int START_YEAR;
	int START_MONTH;
	int END_YEAR;
	int END_MONTH;

	if (argc == 7) {
		COUNTRY = argv[1];
		//STATE = argv[2];
		VARIABLE = argv[2];
		START_YEAR = atoi(argv[3]);
		START_MONTH = atoi(argv[4]);
		END_YEAR = atoi(argv[5]);
		END_MONTH = atoi(argv[6]);
	} else {
		cout << "Incorrect number of inputs" << endl;
		exit(-1);
	}

	string line, country, state;
	double lat, lon, elev;
	int stn_id;
	string stn_id_str;

	string stn_name, date_start, date_end;
	ifstream stnFile, stnFileName;

	stnFile.open("./cmd/stationinfo.txt");
	infFile = fopen("./cmd/Tmax/tmaxncdc.inf", "w");
	out = fopen("./cmd/Tmax/tmaxncdc.daily", "w");

	string data_path = "./cmd/climate/"; //should end with /
	int num_stations = 0;

	while (stnFile.good()) {

		getline(stnFile, line);
		//cout << line << endl;
		
		if (line.substr(0, 2) == COUNTRY) {
			//string parts[] = NULL; // = line.split(",");

			string parts[10];
                        int count = tokenize(line, parts);

			lat = atof(parts[2].c_str());
			lon = atof(parts[1].c_str());
			elev = atof(parts[3].c_str());
			stn_id_str = parts[0].substr(5,6);
			stn_id = atoi(stn_id_str.c_str());
/*
			lat = atof((line.substr(13, 7)).c_str());
			lon = atof((line.substr(21, 9)).c_str());
			elev = atoi((line.substr(32, 5)).c_str());
			stn_id_str = line.substr(5, 6);
			stn_id = atoi(stn_id_str.c_str());
*/	
			cout << stn_id << " " << stn_id_str << endl;
			if (stn_id == 0) {
				//if conversion to numeric fails
				for(int i = 0; i < stn_id_str.length(); i++)
     				{
			          char ch = stn_id_str[i];
				  //cout << ch << endl;
				  if (!(ch >= '0' && ch <= '9')) stn_id_str[i] = '0';
     				}
				//cout << " Converted " << stn_id_str << endl;			
			}
			
			stn_name = parts[4];
			string dly_file = data_path + parts[0].c_str(); // data file has no extention .dly


			bool foundData = processData(dly_file, START_YEAR, END_YEAR,
					VARIABLE, stn_id_str, stn_name);
			if (foundData) {
				fprintf(infFile,
						"   %7.4f   %8.4f   %6.1f %-29s %6s %4s\n", lat,
						lon, elev, stn_name.c_str(), stn_id_str.c_str(), VARIABLE.c_str());
				num_stations++;
				//cout << line << endl;
			}
		}
	}

	fclose(infFile);
	fclose(out);
	stnFile.close();
	return 0;
}

bool processData(string filename, int year_start, int year_end, string variable,
		string stn_id, string stn_name) {

	ifstream in;
	string line;

	string stn_id_formatted_str = stn_id.substr(2, stn_id.length() - 2);
	int stn_id_formatted_int;
	stringstream ss0(stn_id_formatted_str);
	ss0 >> stn_id_formatted_int;

	in.open(filename.c_str());
	if (!in.is_open()) {
		cout << filename << " not found" << endl;
		return false;
	}

	int year, month, tot_days = 0;
	bool foundData = false;

	//start reading the file
	getline(in, line);

	string ** datalines = new string*[year_end-year_start+1];
	for (int i=0; i < year_end-year_start+1; i++) {
		datalines[i] = new string[13];
		for (int j=0; j < 13; j++) {
                  datalines[i][j] = "";
		}
	}
	while (in.good()) 
        {
		string varname = line.substr(17, 4);
		string str_year = line.substr(11, 4);
		string str_month = line.substr(15, 2);

		stringstream ss(str_year);
		ss >> year;

		stringstream ss1(str_month);
		ss1 >> month;

		if ((variable == varname) && (year >= year_start) && (year <= year_end)) 
		{			
			//cout << year << " " << month << " " << line << endl;
			datalines[year - year_start][month] = line;
			foundData = true;
		}

		getline(in, line);
	}
	in.close();

	if (foundData) {
		string dataline = "";
		for (year=year_start; year<=year_end; year++) {
			fprintf(out, "%6d %-29s %4d\n ", stn_id_formatted_int, stn_name.c_str(), year);
			for (month=1; month<13; month++) {
				dataline = datalines[year-year_start][month];
				if (dataline != "") {
					writeRecord(dataline, month);
				} else {
					writeMissingMonth(month);
				}
			}
			fprintf(out, "\n");
		}
	}
	return foundData;
}

void writeMissingMonth(int month) {
	for (int i = 0; i < days_in_month[month]; i++) {
		fprintf(out, "%d ", NO_DATA);
	}
}

void writeRecord(string line, int month) {
	int length = line.length();
	int num_vals = (length - 21) / 8;
	int tot_days = days_in_month[month];
	for (int j = 0; j < num_vals; j++) {
		string token = line.substr(21 + j * 8, 8);
		string val = token.substr(0, 5);
		double tmax = 0;
		stringstream ss(val);
		ss >> tmax;
		if (j == tot_days) {
			//cout << "End of month reached " << j << endl;
			break;
		}
		if (tmax >= 0.0) {
			fprintf(out, "%.2f ", (tmax/10.) * 1.8 + 32.0);
		} else {
			fprintf(out, "%d ", -99);
		}
	}
}

int str2int(string str) {
	int val = -999999;
	stringstream ss(str);
	ss >> val;
	return val;
}

double str2double(string str) {
	double val = -999999;
	stringstream ss(str);
	ss >> val;
	return val;
}
