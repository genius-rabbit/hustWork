`timescale 1ns / 1ps
module MainClock(
	input CP50, //ʱ���ź�
	input Ctrl24To12, //24Сʱ��12Сʱ����ת��
	input nCR,EN, //�����ʹ���ź�
	input SwitchMHToS,DisplayA, //�л���ʾ�����ʾСʱ�ͷ��ӵ��ź�
	input AdjH,AdjM, //����Сʱ������ź�
	
	output LEDAlarm,LED0,LEDZ, //���ӵƣ�����ƣ����㱨ʱ��
	output [3:0] Choose, //���ѡ���ź�
	output [6:0] HEX //����ź�
    );


wire [6:0] HEX0,HEX1,HEX2,HEX3;
wire CP1;
wire CP1000;
wire [7:0] Hour,Minutes,Second;
wire [7:0] AHour,AMinutes;
supply1 vdd;


//����ģ��
Divider50MHz U0(.CLK_50M(CP50),
					 .nCLR(nCR),
					 .CLK_1HzOut(CP1));
defparam U0.N=25,
		 U0.CLK_Freq=50000000,//����Ƶ��50MHz
		 U0.OUT_Freq=1;		 //���Ƶ��1Hz
		 
////////////��ʱ����///////////
//��
Counter10 S0(CP1,nCR,EN,Second[3:0]);
Counter6  S1((Second[3:0]==4'h0),nCR,EN,Second[7:4]);

//����
Counter10 M0(CP1,nCR,MinL_EN,Minutes[3:0]);
Counter6  M1(CP1,nCR,MinH_EN,Minutes[7:4]);
//����ʹ���ź�
assign MinL_EN=(AdjM&&(DisplayA==0))? 1:(Second==8'h59);
assign MinH_EN=(((AdjM&&(DisplayA==0))&&(Minutes[3:0]==4'h0))||((Minutes[3:0]==4'h0)&&(Second==8'h00)));

//Сʱ
Counter24 H0(Hour[7:4],Hour[3:0],CP1,nCR,Hour_EN,Ctrl24To12);
//Сʱʹ���ź�
assign Hour_EN=(AdjH&&!DisplayA)? vdd:((Minutes==8'h00)&&(Second==8'h00));




///////////////���㱨ʱģ��/////////////////////////
Zhengdian Z0((Second>=8'h00&&Second<Hour&&Minutes==8'h00),CP1,nCR,LEDZ);




///////////////����ģ��////////////////////////////
//���ӵ����ź�
Alarm Al(((AHour==Hour)&&(AMinutes==Minutes)),CP1,nCR,LEDAlarm);

//���ӷ���
Counter10 AM0(CP1,nCR,AMinL_EN,AMinutes[3:0]);
Counter6  AM1(CP1,nCR,AMinH_EN,AMinutes[7:4]);
//���ӷ���ʹ���ź�
assign AMinL_EN=(AdjM&&DisplayA)? vdd:0;
assign AMinH_EN=((AdjM&&DisplayA)&&(Minutes[3:0]==4'h9));
//����Сʱ�ź�
Counter24 AH0(AHour[7:4],AHour[3:0],CP1,nCR,AHour_EN,Ctrl24To12,LED0);
//����Сʱʹ���ź�
assign AHour_EN=(AdjH&&DisplayA)? vdd:(Minutes==8'h59);



//////////////////��ʾ����ģ��////////////////////////
DisplayControl D(Hour,Minutes,Second,AHour,AMinutes,SwitchMHToS,DisplayA,CP1,HEX0,HEX1,HEX2,HEX3);
//Hour,Minutes,Second,AHour,AMinutes,----��ʾѡ��
//SwitchMHToS,DisplayA,CP1-----------------��ʾ����
//HEX0,HEX1,HEX2,HEX3--------------------��ʾ���



//////////////////ˢ�¿���ģ��/////////////////////////
Divider1000 Di0(.CLK_50M(CP50),
					 .nCLR(nCR),
					 .CLK_1HzOut(CP1000));
defparam Di0.N=25,
		 Di0.CLK_Freq=50000000,//����Ƶ��50MHz
		 Di0.OUT_Freq=100;	//���Ƶ��100Hz	 
//ˢ�¿���
Refresh R0(CP1000,HEX,Choose,HEX0,HEX1,HEX2,HEX3,nCR);

endmodule
