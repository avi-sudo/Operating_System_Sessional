#include<iostream>
#include<cstdio>
#include<pthread.h>
#include<unistd.h>
#include<semaphore.h>
#include<cstring>
#include <time.h>

using namespace std;

#define number_of_cycles 10
#define S 3
#define C 2
#define arr_size 1

int ind = 0;
unsigned int seed;
sem_t full_array, empty_array;
pthread_mutex_t mutex1,mutex2,mutex3,mutex4;
sem_t array[S];
int cycleCount=0;
int departCount=0;
sem_t rd,wt,rd2;

void* servicing(void* arg){
    int i;
    sem_wait(&rd);
    
    //sem_wait(&rd2);
    //pthread_mutex_lock(&mutex4);
    /*pthread_mutex_lock(&mutex1);
    cycleCount++;
    pthread_mutex_unlock(&mutex1);
    if(cycleCount==1){
         sem_wait(&wt);
     }*/
    for (i=0;i<S;i++){
        sem_wait(&array[i]);
        /*if(i!=0){
            sem_post(&rd);
            
        }*/
        if(i==0){
            sem_wait(&rd2);
            
            pthread_mutex_lock(&mutex1);
            cycleCount++;
            
            if(cycleCount==1){
                sem_wait(&wt);
             }
			 pthread_mutex_unlock(&mutex1);
            printf("%s started taking service from serviceman %d\n",(char*)arg,i+1);
            fflush(stdout);
            sem_post(&rd2);
             
        }
        else{
             printf("%s started taking service from serviceman %d\n",(char*)arg,i+1);
             fflush(stdout);
        }
        
        //sleep(3);
        if(i!=0){
            
            sem_post(&array[i-1]);
			sem_post(&rd);
        }
        int e=(rand_r(&seed)%3)+1;
        //printf("%d\n",e);
        //sleep(e);
        usleep((rand()%5000)+1);
       // sleep((rand_r(&seed)%3)+1);
        
        printf("%s finished taking service from serviceman %d\n",(char*)arg,i+1);
        fflush(stdout);
        if(S==1){
            sem_post(&rd);
        }
        
    }
    sem_post(&array[i-1]);
    pthread_mutex_lock(&mutex1);
        cycleCount--;
        
        if(cycleCount==0){
            sem_post(&wt);
        }
		pthread_mutex_unlock(&mutex1);
}
void* payment(void* arg){
    sem_wait(&empty_array);
    printf("%s started paying the service bill\n",(char*)arg);
    fflush(stdout);
    //sleep(5);
    int d=(rand_r(&seed)%3)+1;
        //printf("%d\n",d);
        //sleep(d);
    //sleep((rand_r(&seed)%3)+1);
    usleep((rand()%5000)+1);
    pthread_mutex_lock(&mutex2);
    departCount++;
    
    if(departCount==1){
        sem_wait(&rd2);
        
    }
	pthread_mutex_unlock(&mutex2);
    printf("%s finished paying the service bill\n",(char*)arg);
    fflush(stdout);
    sem_post(&empty_array);
}
void* departure(void* arg){
   /* pthread_mutex_lock(&mutex2);
    departCount++;
    pthread_mutex_unlock(&mutex2);
    if(departCount==1){
        sem_wait(&rd2);
        
    }*/
    sem_wait(&wt);
    printf("%s has departed\n",(char*)arg);
    fflush(stdout);
    //sleep((rand_r(&seed)%3)+1);
    usleep((rand()%5000)+1);
    sem_post(&wt);
    pthread_mutex_lock(&mutex2);
    departCount--;
    
    if(departCount==0){
        sem_post(&rd2);
        
    }
	pthread_mutex_unlock(&mutex2);
}
void* produce_item(void* arg){
    
    servicing((char*)arg);
    payment((char*)arg);
    departure((char*)arg);
    
    
        
    pthread_exit(arg);
    //pthread_exit((void*)strcat((char*)arg," producer is finishing\n"));
}
int main(int argc, char* argv[])
{
    int res;
    for(int i=0;i<S;i++){
        res=sem_init(&array[i],0,1);
        if(res != 0){
            printf("Failed\n");
         }
    }
    res = sem_init(&empty_array,0,C);
    if(res != 0){
        printf("Failed\n");
    }

    res = sem_init(&full_array,0,0);
    if(res != 0){
        printf("Failed\n");
    }

    res = pthread_mutex_init(&mutex1,NULL);
    if(res != 0){
        printf("Failed\n");
    }
    res = pthread_mutex_init(&mutex2,NULL);
    if(res != 0){
        printf("Failed\n");
    }
    res = sem_init(&rd,0,1);
    if(res != 0){
        printf("Failed\n");
    }
    res = sem_init(&wt,0,1);
    if(res != 0){
        printf("Failed\n");
    }
    res = sem_init(&rd2,0,1);
    if(res != 0){
        printf("Failed\n");
    }
    res = pthread_mutex_init(&mutex3,NULL);
    if(res != 0){
        printf("Failed\n");
    }
    res = pthread_mutex_init(&mutex4,NULL);
    if(res != 0){
        printf("Failed\n");
    }
    pthread_t producers[number_of_cycles];
    for(int i = 0; i < number_of_cycles; i++){
        char *id = new char[3];
        strcpy(id,to_string(i+1).c_str());

        res = pthread_create(&producers[i],NULL,produce_item,(void *)id);

        if(res != 0){
            printf("Thread creation failed\n");
        }
    }

    

    for(int i = 0; i < number_of_cycles; i++){
        void *result;
        pthread_join(producers[i],&result);
       // printf("%s",(char*)result);
    }

    
    for(int i=0;i<S;i++){
        res=sem_destroy(&array[i]);
        if(res != 0){
            printf("Failed\n");
         }
    }
    res = sem_destroy(&full_array);
    if(res != 0){
        printf("Failed\n");
    }
    res = sem_destroy(&empty_array);
    if(res != 0){
        printf("Failed\n");
    }

    res = pthread_mutex_destroy(&mutex1);
    if(res != 0){
        printf("Failed\n");
    }
    res = pthread_mutex_destroy(&mutex2);
    if(res != 0){
        printf("Failed\n");
    }
    res = sem_destroy(&rd);
    if(res != 0){
        printf("Failed\n");
    }
    res = sem_destroy(&wt);
    if(res != 0){
        printf("Failed\n");
    }
    res = sem_destroy(&rd2);
    if(res != 0){
        printf("Failed\n");
    }
    res = pthread_mutex_destroy(&mutex3);
    if(res != 0){
        printf("Failed\n");
    }
    res = pthread_mutex_destroy(&mutex4);
    if(res != 0){
        printf("Failed\n");
    }
    return 0;
}
