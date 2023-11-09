#include <iostream>
#include <string>
#include <unordered_map>
#include <fstream>
#include <sys/stat.h>
#include <cstring>
#include <algorithm>
#define BUFFER_SIZE     40960
class countWord
{
    private:
        char buffer[BUFFER_SIZE];
        std::unordered_map<std::string,int> maps;
        std::string fileName;
        std::fstream file;
        size_t fileSize;
    public:
        countWord()
        {
            memset(buffer,'\0',BUFFER_SIZE);
        };
        ~countWord()
        {
            file.close();
        }
        bool openFile(const std::string &_fileName)
        {
            file.open(_fileName,std::fstream::in);
            if(!file.is_open())
            {
                std::cout<<"Error file open"<<std::endl;
                return false;
            }
            fileName = _fileName;
            struct stat statbuf;
            stat(fileName.c_str(), &statbuf);
            fileSize = statbuf.st_size;
            return true;
        }
        void count()
        {
            while(!file.eof())
            {
                memset(buffer,'\0',BUFFER_SIZE);
                file.read(buffer,BUFFER_SIZE-1);
                /*读取不完整 导致单个单词分裂 文件指针回退*/
                int offset = reverseFilePtr();
                if(offset > 0)
                    file.seekg(-offset,std::ios::cur);
                countInfo();
            }
        }
        void printInfo()
        {
            for(auto i:maps)
                std::cout<<i.first<<" : "<<i.second<<std::endl;
        }
        int findWord(const std::string &str)
        {
            return maps[str];
        }
    private:
        void countInfo()
        {
            char *i = std::find_if(buffer,buffer+BUFFER_SIZE-1,isSplit);
            int checkIdx = 0;
            while((*i) != '\0')
            {
                int index = i - buffer;
                std::string word(buffer+checkIdx,i);
                maps[word]++;
                checkIdx = index+1;
                i = std::find_if(i+1,buffer+BUFFER_SIZE-1,isSplit);
            }
            std::string word(buffer+checkIdx,i);
            maps[word]++;
        }
        int reverseFilePtr()
        {
            int index = BUFFER_SIZE - 1;
            int ans = 0;
            while(buffer[index]!= '\0' && index >= 0 && !isSplit(buffer[index]))
            {
                index--;
                ans++;
            }
            return ans-1;
        }
        static bool isSplit(char ch)
        {
            return ch == ' ' || ch == ',' || ch == '.' 
                    || ch == '!' || ch == '?' || ch == '\"' 
                    || ch == ')' && ch == '(' || std::isdigit(ch)
                    || ch == '\n' || ch == ':';
        }
};
int main(int argc,char *argv[])
{
    countWord countW;
    /*打开文件*/
    countW.openFile(argv[1]);
    /*开始统计*/
    countW.count();
    /*展示所有统计信息*/
    countW.printInfo();
    /*查询单个单词*/
    int weCount = countW.findWord("we");
    std::cout<<"==================="<<std::endl;
    std::cout<<"we : "<<weCount<<std::endl;
    return 0;
}