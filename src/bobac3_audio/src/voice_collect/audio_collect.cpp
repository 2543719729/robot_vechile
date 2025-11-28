#include "audio_collect.h"

#include "wav.h"

AudioCollect::AudioCollect():m_cap(new AudioCap("default")), m_vad(new VadAlgorithm(16000, 1, 16))
{
    if(m_cap) {
        m_cap->start();
        usleep(30*1000);
    }
    if(m_vad && m_cap->is_capture()) {
        m_vad->env_detect(m_cap->get_current_frames(), m_cap->get_buffer_size(), 20);
    }
    m_cap->wait_flag = true;
    m_work_flag = true;
    m_work_thread = boost::thread(boost::bind(&AudioCollect::work, this));

}

void AudioCollect::work()
{
	m_collect_flag=false;
	size_t size = m_cap->get_buffer_size();
	while(m_work_flag) {
		boost::mutex::scoped_lock lock(m_mutex);
		boost::shared_ptr<char> tem = m_cap->get_current_frames();
		// 仅在需要录音时缓存数据，其余时间丢弃，避免无限增长
		if(m_collect_flag) {
			m_collecter.push_back(tem);
		}
	}
}

std::vector<boost::shared_ptr<char> > AudioCollect::get_voice()
{
	size_t  size = m_cap->get_buffer_size();
	m_voice.clear();
	// 每次调用从空缓存开始
	m_collecter.clear();
	m_cap->wait_flag = false;
	// 开始录音
	m_collect_flag = true;
	const int RECORD_LOOP = 200;      // 录音循环次数
	const int SLEEP_US    = 20000;    // 每次循环睡眠 20ms，总计约 4 秒
	for(int i = 0; i < RECORD_LOOP; ++i) {
		printf("****************************\n");
		usleep(SLEEP_US);
	}
	// 停止录音
	m_collect_flag = false;
	std::cout << "collecter size: " << m_collecter.size() << std::endl;
	m_voice = m_collecter;
	m_cap->wait_flag = true;
	m_collecter.clear();
	return m_voice;
}

void AudioCollect::write_wav(std::vector<boost::shared_ptr<char> > voice, std::string fname)
{
    std::string	file_name = fname;
    size_t size = m_cap->get_buffer_size();
    FILE* fp = fopen(file_name.c_str(), "wb+");
    fwrite(&default_wav_hdr, sizeof(default_wav_hdr) ,1, fp);
    for(int i=0; i<voice.size(); i++) {
        char* buf = voice[i].get();
        if(buf) {
            fwrite(buf, 2*size, 1, fp);
            default_wav_hdr.data_size += 2*size;
        }
    }

    default_wav_hdr.size_8 += default_wav_hdr.data_size + (sizeof(default_wav_hdr) - 8);
    fseek(fp, 4, 0);
    fwrite(&default_wav_hdr.size_8,sizeof(default_wav_hdr.size_8), 1, fp); //写入size_8的值
    fseek(fp, 40, 0); //将文件指针偏移到存储data_size值的位置
    fwrite(&default_wav_hdr.data_size,sizeof(default_wav_hdr.data_size), 1, fp); //写入data_size的值

    fclose(fp);
}

