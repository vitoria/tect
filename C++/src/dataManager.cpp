#include <dataManager.h>

using namespace std;

string * arquiveToArray(fstream arquive, int size){

    string arquive_split[size];
    string fileOutput;

    for (int i = 0; i < size; i++ ){
        string aux = "";
        do{
            getline(arquive, fileOutput);
            aux += fileOutput;
        } while(fileOutput != "*");
        arquive_split[i] = aux;
    }

    return arquive_split;
}

void arrayToArquive(string array[], fstream arquive, int size){

     for (int i = 0; i < size; i++ ){
        arquive << array[i];
    }
}