$PBExportHeader$uo_park_apuracao_opcao.sru
forward
global type uo_park_apuracao_opcao from nonvisualobject
end type
end forward

global type uo_park_apuracao_opcao from nonvisualobject
event ou_alerta_lanca_caixa_fechado ( ref long ouws_reg_caixa )
end type
global uo_park_apuracao_opcao uo_park_apuracao_opcao

type variables

end variables

forward prototypes
public function boolean fs_rotina_apuracao_contratado ()
public function boolean fs_rotina_apuracao_rotativo (ref string wsf_msg_erro_db[], ref integer wsf_cod_erro_db)
public function boolean fs_apuracao_rotativo_rot01 (ref string wsf_msg_erro_db[], ref integer wsf_cod_erro_db)
public function boolean fs_apuracao_rotativo_rot02 (ref string wsf_msg_erro_db[], integer wsf_cod_erro_db)
public function boolean fs_rot_apur_recupera_saldo_placa (ref decimal wsf_saldo_anterior, ref string wsf_deb_cred, ref string wsf_msg_erro_db[], ref integer wsf_cod_erro_db)
protected function boolean fs_recupera_rotativo_entrada_saidax (ref long wsf_num_contrato, ref string wsf_cod_cartao, ref string wsf_cod_placa, ref datetime wsf_data_entrada, ref datetime wsf_data_saida, ref string wsf_msg_erro_db[], ref integer wsf_cod_erro_db)
public function boolean fs_rotina_apuracao (ref string wsf_msg_erro_db[], ref integer wsf_cod_erro_db)
public function boolean fs_qtd_minutos (ref datetime wsf_dta_entrada, ref datetime wsf_dta_saida, ref string wsf_msg_erro_db[], ref integer wsf_cod_erro_db, ref long wsf_qtd_minutos)
public function long fs_recebimento_cheques ()
public function boolean fs_apuracao_rotativo_rot01_tolera (ref string wsf_msg_erro_db[], ref integer wsf_cod_erro_db)
public function boolean fs_cliente_lanca_caixa (ref string wsf_chave_cartao, ref long wsf_chave_contrato, ref string wsf_chave_placa, ref decimal wsf_valor, ref long wsf_chave_tabela_movimento_diario, ref string wsf_msg_erro_db[], ref integer wsf_cod_erro_db, ref string wsf_cod_deb_cred, ref long wsf_chave_cadastro_cheques)
public function boolean fs_receb_mensalista_lanc_caixa (ref long wsf_chave_contrato, ref string wsf_msg_erro_db[], ref integer wsf_cod_erro_db, ref string wsf_cod_deb_cred, ref decimal wsf_valor, ref long wsf_chave_cadastro_cheques, ref long wsf_chave_fechamento_contrato, ref long wsf_chave_lancamentos_caixa)
public function boolean fs_rot_apur_efetiva_lancamto (ref long wsf_chave_contrato, ref string wsf_chave_cartao, ref string wsf_cod_placa, ref string wsf_cod_lancamento, ref decimal wsf_valor_lancamento, ref long wsf_carimbo_lanc_caixa, ref long wsf_cod_lanca_mov_diario, ref string wsf_msg_erro_db[], ref integer wsf_cod_erro_db, ref string wsf_conta_cliente_obs[], ref string wsf_cod_tipo_contrato)
end prototypes

event ou_alerta_lanca_caixa_fechado(ref long ouws_reg_caixa);/*   */ 
string wsf_msg_erro_db[]
Int      wsf_cod_erro_db 

datetime  WS_data_hora_Lancamento 
dec{2}      WS_Valor_lancamento 
string       WS_Desc_lancamanto_Caixa 
Long        WS_Chave_contratos 
Long        WS_chave_caixa_lancamentos
String       WS_tipo_contrato
////////////////////////////////////////////////////////////
SELECT PARK_Caixa_Lancamentos.data_hora_Lancamento, 
             PARK_Caixa_Lancamentos.Valor_lancamento, 
             PARK_Caixa_Lancamentos_HIST.Desc_lancamanto_Caixa, 
             PARK_Caixa_Lancamentos.Chave_contratos, 
             PARK_Caixa_Lancamentos.chave_caixa_lancamentos
INTO		:WS_data_hora_Lancamento, 
              :WS_Valor_lancamento ,
              :WS_Desc_lancamanto_Caixa ,
              :WS_Chave_contratos ,
               :WS_chave_caixa_lancamentos		 
FROM PARK_Caixa_Lancamentos INNER JOIN PARK_Caixa_Lancamentos_HIST ON 
           PARK_Caixa_Lancamentos.cod_lancamentos   = PARK_Caixa_Lancamentos_HIST.cod_lancamento_caixa
WHERE  PARK_Caixa_Lancamentos.chave_caixa_lancamentos  = :ouws_reg_caixa
   Using SQLCA;
       //
 IF SQLCA.SQLCODE  <> 0   then  
	 messagebox("Falha DB ", "não foram  carimbados os registros da conta cliente ~n  " +  SQLCA.SQLERRTEXT   )
 End if				
			
IF isnull( WS_Chave_contratos) = false then
	IF WS_Chave_contratos > 0 Then 
              SELECT  PARK_Contratos_Tipo.desc_tipo_contrato
                   INTO  :ws_tipo_contrato
                 FROM     PARK_Contratos INNER JOIN PARK_Contratos_Tipo ON 
                                PARK_Contratos.Tipo_contrato = PARK_Contratos_Tipo.cod_tipo_contrato
                  WHERE  PARK_Contratos.chave_contratos =   :WS_Chave_contratos
                  Using SQLCA;
      End IF			
End IF			

IF isnull(ws_tipo_contrato)  = true then
	ws_tipo_contrato = " "
End IF
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	  UO_SCA_01 lnv_SCA_01
       lnv_SCA_01 = Create using "UO_SCA_01"
			    string  WS_Titulo_ocorrencia
                  string  WS_texto_ocorrencia[]
                  long    WS_autor_ocorrencia
                  WS_autor_ocorrencia = 3

                  WS_Titulo_ocorrencia = "ATENÇÃO - Lançamento Com caixa Fechado"
                  WS_texto_ocorrencia[1] = "Neste momento ocorreu uma movimentação no caixa "
                  WS_texto_ocorrencia[2] = "mas NÂO tem caixa aberto. Isto poderá dificultar a conferência dos valores. "
			     WS_texto_ocorrencia[3] = "Os valores serão guardados e lançados no próximo caixa que for aberto!"
				WS_texto_ocorrencia[4] =  "Data Lançamento =  " +  string(WS_data_hora_Lancamento, "dd/mm/yyyy hh:mm:ss") 
				WS_texto_ocorrencia[5] =  "Valor =  " +   string(WS_Valor_lancamento, "#,###0.00")
				WS_texto_ocorrencia[6] =  "Descição = " + trim(WS_Desc_lancamanto_Caixa) + "  " + trim(ws_tipo_contrato)
                   WS_texto_ocorrencia[7] = "Registro do caixa = " + string(WS_chave_caixa_lancamentos)
                   WS_texto_ocorrencia[8] = "Operador: " + str_dados_Operador.stru_codigo_usuario_operador
                   lnv_SCA_01.fs_grava_ocorrencia( WS_Titulo_ocorrencia, WS_texto_ocorrencia, WS_autor_ocorrencia) 	
						 
                   string ws_livro_operador[]
				 ws_livro_operador[01]  =  "Movimentação em caixa Fechado. Registro do caixa = " +  string(WS_chave_caixa_lancamentos)
                   lnv_SCA_01.fs_grava_ocorrencia_usuario(ws_livro_operador,                                           &
	                                                                           STR_Dados_Operador.stru_chave_operador,      &
														                 WS_autor_ocorrencia)
        destroy lnv_SCA_01 	
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
INSERT into PARK_Caixa_lancamentos_OBS
            (
			 chave_caixa_lancamentos,
              Cod_seq_observacao, 
              desc_observacao
			)
Values (
             :WS_chave_caixa_lancamentos,
             1,
			'Lançamento em caixa fechado'
			)
Using SQLCA;
////////////////////////////////////////////////////////////////////////
 

end event

public function boolean fs_rotina_apuracao_contratado ();
//messagebox("Cheguei aqui", "fs_rotina_apuracao_Contratado")
Return true
end function

public function boolean fs_rotina_apuracao_rotativo (ref string wsf_msg_erro_db[], ref integer wsf_cod_erro_db);/* Rotina de apuração dos serviços ROTATIVOS  */
/* Neste serviço o cliente tem direito a uma entrada e uma saida */
/* verificar se o pagamento será na entrada ou na saída *//*str_dados_Contratos.CONTr_TP_Tp_pgmto 1 = entrada 2 = saida */
/*verificar o tipo de preço *//* str_dados_Contratos.CONTr_TP_Cod_Tp_preco  1 = preço p/ hora - 2 = preço fixo */
/////////////////
dec {2} ws_saldo_anterior 
string    ws_deb_cred
string ws_conta_cliente_obs[]
string ws_cod_lanc
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
STR_Dados_placa.lancou_periodo_inicial_II = false
///
/* CR 01 - movimento = Rotativo */ 
 IF STR_Dados_Placa.oper_Atual_entr_sai =  1    then  /* movimentação atual é uma entrada */
             IF not STR_Dados_placa.EH_Placa_nova then   /* se não for placa nova, apura saldo anterior */
                     IF fs_rot_apur_recupera_saldo_placa( ws_saldo_anterior, ws_deb_cred, wsf_msg_erro_db,   wsf_cod_erro_db) then

				 End IF
		   End IF
		   IF str_dados_Contrato.contr_tp_qtd_minutos_toleranci = 0  Then
                     IF Not fs_Apuracao_Rotativo_Rot01(wsf_msg_erro_db, wsf_cod_erro_db)     then  /*  apurar e fazer o lancamento na conta cliente  em movimento de entrata*/
                               Return false
		           End If
		   END IF	
             IF str_dados_Contrato.contr_tp_tipo_pagamento = "1" then  /* Pagamento na entrada */
		         openwithparm(PARK_Conta_cliente, "fs_rotina_apuracao_rotativo_Cob_Ent")		/* apresenta a tela de conta cliente com botão de fechamento */
	        End IF
ELSEIF  STR_Dados_Placa.oper_Atual_entr_sai  =  2  then   /* movimentação atual é uma saida */
	/*  teste */
	    IF STR_Dados_Placa.QTD_Minutos   >  STR_Dados_Contrato.contr_tp_qtd_minutos_toleranci   and   &
			    STR_Dados_Contrato.contr_tp_qtd_minutos_toleranci > 0 then
 	               IF Not fs_Apuracao_Rotativo_Rot01(wsf_msg_erro_db, wsf_cod_erro_db)     then  /*  apurar e fazer o lancamento na conta cliente  */
                            Return false
		           End If
		    Else	
				 IF STR_Dados_Contrato.contr_tp_qtd_minutos_toleranci > 0 then
			             IF Not fs_Apuracao_Rotativo_Rot01_Tolera(wsf_msg_erro_db, wsf_cod_erro_db)     then  /*  apurar e fazer o lancamento na conta cliente  tolerancia*/
                                       Return false
		                  End If
				 END IF
	     End IF
    /*  teste  FIM */
	 	 IF str_dados_Contrato.contr_tp_qtd_minutos_toleranci > 0  Then
      	        IF Not fs_Apuracao_Rotativo_Rot02( wsf_msg_erro_db, wsf_cod_erro_db )     then  /*  apurar e fazer o lancamento na conta cliente  em movimento de saida*/
                         Return false
		        End If
		 END IF  
	       //
	     IF str_dados_Contrato.contr_tp_tipo_pagamento = "2" then  /* Pagamento na Saida */
		  //	 IF str_dados_Contrato.contr_tp_qtd_minutos_toleranci >  0   Then
		          pagina_inicio.Trigger Event ou_mostra_itens_conta_cliente(STR_dados_Cartao.chave_movimento_diario)
		//	End IF
//		    openwithparm(PARK_Conta_cliente, "fs_rotina_apuracao_rotativo_Cob_Sai")		/* apresenta a tela de conta cliente com botão de fechamanto */
	     End IF
End IF
//

Return true

end function

public function boolean fs_apuracao_rotativo_rot01 (ref string wsf_msg_erro_db[], ref integer wsf_cod_erro_db);/*  apurar e fazer o lancamento na conta cliente  em movimento de entrata   Lançar o periodo inicial e o desconto se houver   
     procedimentos diferentes para preço fixo e variavel  verificação do tipo de preço 1 pgmt hora e 2 preço fixo  
     sendo preço fixo lançar na conta cliente o valor apurado  sendo preço hora, lançar o valor da parte inicial  */
	
 /* CR 01 */ /* verificação do tipo de preço */
	  long         ws_carimbo_lanc_caixa,  Ws_chave_preco_variavel, Ws_chave_preco_fixo
  	  string       Ws_codigo_lancamento, Ws_Conta_Cliente_Obs[]
	  dec {2}     ws_valor_lancamento

	  datetime   Ws_data_pagmto, Ws_data_Vigencia 
///////////////////////////////////////////////////////////////////////////////////////////////////////////////	  
	  ws_conta_cliente_obs[1] = "Lançamento automático feito pelo Sistema"
	  ws_conta_cliente_obs[2] = "Conforme Contrato"
       ws_carimbo_lanc_caixa  = 000
//	  
 IF  str_dados_Contrato.contr_tp_cod_tipo_preco  =  "1" then   /* Preço por hora */
      /* lanca periodo inicial *//* se houver, lança desconto sobre o periodo inicial */
	  string         Ws_query_lancamento,                     Ws_Cod_lanc_cta_cliente_periodo_inicial, Ws_Cod_lanc_cta_cliente_periodo_inicial_ii
	  string         Ws_Cod_lanc_cta_cliente_Fracao, Ws_Cod_lanc_cta_cliente_periodo_inicial_DescTo, Ws_Cod_lanc_cta_cliente_Fracao_DescTo
        Int              Ws_QTD_Minutos_periodo_Inicial,  Ws_QTD_Minutos_periodo_Inicial_II, Ws_QTD_minutos_fracao, Ws_sequencia_lancamento
        Dec {2}     Ws_Valor_preco_periodo_inicial,    Ws_Valor_preco_periodo_inicial_ii,  Ws_Valor_preco_Fracao
	   Long         Ws_cod_lanc_mo_dia		
	   Datetime  Ws_dta_lancamento
       //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	   Ws_dta_lancamento      =  Datetime(today(), now())
         Ws_cod_lanc_mo_dia  =  0000	
       /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//       WS_data_pagmto  =  datetime(today(), time( "00:00:01" ))
         WS_data_pagmto  = STR_Dados_Placa.data_entrada
         Setnull( Ws_data_Vigencia )
        SELECT  MAX(data_inicio_vigencia_preco_variavel)	 
             INTO  :Ws_data_Vigencia
	      FROM 	PARK_Preco_Variavel_Hora 	
         WHERE 	PARK_Preco_Variavel_Hora.Codigo_Tipo_vaga                                  =    :STR_Dados_Placa.cod_tipo_vaga	                             AND
			         PARK_Preco_Variavel_Hora.cod_tipo_contrato                                      =    :STR_dados_Contrato.contr_tp_cod_tipo_contrato       AND
				    PARK_Preco_Variavel_Hora.data_inicio_vigencia_preco_variavel    <=   :WS_data_pagmto
             Using SQLCA;
 
         SELECT  PARK_Preco_Variavel_Hora.Chave_preco_variavel_hora
              INTO    :WS_chave_preco_variavel
	        FROM 	PARK_Preco_Variavel_Hora 	
          WHERE 	PARK_Preco_Variavel_Hora.Codigo_Tipo_vaga                                       =    :STR_Dados_Placa.cod_tipo_vaga	                             AND
			              PARK_Preco_Variavel_Hora.cod_tipo_contrato                                      =    :STR_dados_Contrato.contr_tp_cod_tipo_contrato       AND
				         PARK_Preco_Variavel_Hora.data_inicio_vigencia_preco_variavel     =   :Ws_data_Vigencia
                 Using SQLCA;
            //////////////////////////////////////////////////////////////////////////////////////////////////////////////		
           SELECT    PARK_Preco_Variavel_Hora.QTD_Minutos_periodo_Inicial, 
			               PARK_Preco_Variavel_Hora.QTD_Minutos_periodo_Inicial_II,
	                         PARK_Preco_Variavel_Hora.QTD_minutos_fracao, 
	                         PARK_Preco_Variavel_Hora.Valor_preco_periodo_inicial, 
					    PARK_Preco_Variavel_Hora.Valor_preco_periodo_inicial_ii,			 
	                         PARK_Preco_Variavel_Hora.Valor_preco_Fracao,
				         PARK_Preco_Variavel_Hora.Cod_lanc_cta_cliente_periodo_inicial	,
					    PARK_Preco_Variavel_Hora.Cod_lanc_cta_cliente_periodo_inicial_ii	,		
				         PARK_Preco_Variavel_Hora.Cod_lanc_cta_cliente_Fracao,
				         PARK_Preco_Variavel_Hora.Cod_lanc_cta_cliente_periodo_inicial_DescTo,
				         PARK_Preco_Variavel_Hora.Cod_lanc_cta_cliente_Fracao_DescTo
                   INTO    :Ws_QTD_Minutos_periodo_Inicial,
					     :Ws_QTD_Minutos_periodo_Inicial_II,
	 	                     :Ws_QTD_minutos_fracao,
                                :Ws_Valor_preco_periodo_inicial,
					     :Ws_Valor_preco_periodo_inicial_ii,				  
	                          :Ws_Valor_preco_Fracao,
				          :Ws_Cod_lanc_cta_cliente_periodo_inicial,	
					     :Ws_Cod_lanc_cta_cliente_periodo_inicial_ii,
				          :Ws_Cod_lanc_cta_cliente_Fracao,
				          :Ws_Cod_lanc_cta_cliente_periodo_inicial_DescTo,
                               :Ws_Cod_lanc_cta_cliente_Fracao_DescTo
	         FROM 	PARK_Preco_Variavel_Hora 				
	      WHERE 	PARK_Preco_Variavel_Hora.Chave_preco_variavel_hora   =  :WS_chave_preco_variavel
              Using SQLCA;
                wsf_msg_erro_db[1]  =  "Falha BD-fs_apuracao_rotativo_rot01 - CR01"
                wsf_msg_erro_db[2]  =   SQLCA.SQLERRTEXT  
                wsf_cod_erro_db       =   SQLCA.SQLCODE
              //
      IF  wsf_cod_erro_db <> 0 then 
		  messagebox("Falha BD - PARK_Preco_Variavel_Hora - CR01","Não foi lançado o valor na conta cliente "  + " ~n "  + &
		                                     wsf_msg_erro_db[1] + "~n " +  wsf_msg_erro_db[2]    )
	      Return false
      End if
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//		  
//        SELECT  PARK_Preco_Variavel_Hora.QTD_Minutos_periodo_Inicial, 
//	                  PARK_Preco_Variavel_Hora.QTD_minutos_fracao, 
//	                  PARK_Preco_Variavel_Hora.Valor_preco_periodo_inicial, 
//	                  PARK_Preco_Variavel_Hora.Valor_preco_Fracao,
//				    PARK_Preco_Variavel_Hora.Cod_lanc_cta_cliente_periodo_inicial,
//				    PARK_Preco_Variavel_Hora.Cod_lanc_cta_cliente_Fracao,
//				    PARK_Preco_Variavel_Hora.Cod_lanc_cta_cliente_periodo_inicial_DescTo,
//				    PARK_Preco_Variavel_Hora.Cod_lanc_cta_cliente_Fracao_DescTo
//        INTO   :Ws_QTD_Minutos_periodo_Inicial,
//	 	           :Ws_QTD_minutos_fracao,
//                  :Ws_Valor_preco_periodo_inicial,
//	                :Ws_Valor_preco_Fracao,
//				   :Ws_Cod_lanc_cta_cliente_periodo_inicial,	
//				   :Ws_Cod_lanc_cta_cliente_Fracao,
//				   :Ws_Cod_lanc_cta_cliente_periodo_inicial_DescTo,
//                  :Ws_Cod_lanc_cta_cliente_Fracao_DescTo
//       FROM  PARK_Preco_Variavel_Hora   
//      WHERE  PARK_Preco_Variavel_Hora.Codigo_Tipo_vaga   =  :STR_Dados_placa.cod_tipo_vaga     and
//		           PARK_Preco_Variavel_Hora.cod_tipo_contrato   =  :STR_dados_Contrato.contr_tp_cod_tipo_contrato
//      Using SQLCA;
//	     
//       wsf_msg_erro_db[1]  =  "Falha BD-fs_apuracao_rotativo_rot01 - CR01"
//      wsf_msg_erro_db[2]  =   SQLCA.SQLERRTEXT  
//      wsf_cod_erro_db       =   SQLCA.SQLCODE
//      //
//      IF  wsf_cod_erro_db <> 0 then 
//		    messagebox("Falha BD-fs_apuracao_rotativo_rot01 - CR01","Não foi lançado o valor na conta cliente "  + " ~n "  + &
//		                                     wsf_msg_erro_db[1] + " " +  wsf_msg_erro_db[2]    )
//	      Return false
//      End if
/////////////////////////////////////////////////////////////
	 /* Calculo do valor periodo inicial */
              /* Lançamento Periodo Inicial */
				  Ws_conta_cliente_obs[2]  =   Ws_conta_cliente_obs[2]               +  " Lançamento Periodo Inicial"
				  Ws_valor_lancamento       =   Ws_Valor_preco_periodo_inicial
				  Ws_codigo_lancamento   =    Ws_Cod_lanc_cta_cliente_periodo_inicial
				  Ws_cod_lanc_mo_dia      =   STR_dados_Cartao.chave_movimento_diario
				  
                        IF Not   FS_ROT_Apur_Efetiva_lancamto(STR_dados_Contrato.contr_chave_contratos,          &
					                                                                       STR_dados_Cartao.chave_cartao,                            &
                                                                                                 STR_Dados_Placa.Cod_Placa,                                  &
																	         Ws_codigo_lancamento,                                             &
					                                                                        Ws_valor_lancamento,                                                 &
																	         Ws_carimbo_lanc_caixa ,                                            &
																	         Ws_cod_lanc_mo_dia,                                                 &
																	         Wsf_msg_erro_db,                                                        &
																	         Wsf_cod_erro_db,                                                         &
																	         Ws_conta_cliente_obs,                                                 &
																	         STR_dados_Contrato.contr_tp_cod_tipo_contrato)              Then
					                Return False
			         End IF			
             /* Lançamento desconto conforme contrato, se houver */
			  IF str_dados_Contrato.contr_percentual_de_desconto  > 0.00 then  /* Tem desconto *//* Então faço lançamento */
				    Ws_valor_lancamento      =  (( Ws_Valor_preco_periodo_inicial * str_dados_Contrato.contr_percentual_de_desconto)  / 100)
				    Ws_codigo_lancamento  =  Ws_Cod_lanc_cta_cliente_periodo_inicial_DescTo
				  //
				     Ws_conta_cliente_obs[3] = "Desconto " + trim(string(str_dados_Contrato.contr_percentual_de_desconto)) +"% S/Periodo Inicial"
					
                           IF Not   FS_ROT_Apur_Efetiva_lancamto(STR_Dados_Contrato.contr_chave_contratos,               &
					                                                                   STR_Dados_Cartao.Chave_Cartao,                               &
                                                                                             STR_Dados_Placa.Cod_Placa,                                    &
																	    Ws_codigo_lancamento,                                              &
					                                                                   Ws_valor_lancamento,                                                  &
																	    Ws_carimbo_lanc_caixa ,                                             &
																	    Ws_cod_lanc_mo_dia,                                                  &
																	    Wsf_msg_erro_db,                                                        &
																	    Wsf_cod_erro_db,                                                         &
																	    Ws_conta_cliente_obs,                                                 &
																		STR_dados_Contrato.contr_tp_cod_tipo_contrato)              Then
					                   Return False
			                 End IF			
			       End IF
             /* Lançamento periodo inicial II conforme contrato, se houver */ 

                   IF Ws_QTD_Minutos_periodo_Inicial_II  >  0  then
				  IF STR_Dados_Placa.QTD_Minutos   > 	Ws_QTD_Minutos_periodo_Inicial  then
                              /* Lançamento Periodo Inicial  II */
				                Ws_conta_cliente_obs[2]   =   ws_conta_cliente_obs[2]               +  " Lançamento Periodo Inicial II"
				                Ws_valor_lancamento        =   Ws_Valor_preco_periodo_inicial_ii
				                Ws_codigo_lancamento    =   Ws_Cod_lanc_cta_cliente_periodo_inicial_ii
				                Ws_cod_lanc_mo_dia       =    STR_dados_Cartao.chave_movimento_diario
									
                                     IF Not   FS_ROT_Apur_Efetiva_lancamto(STR_dados_Contrato.contr_chave_contratos,    &
					                                                                                    STR_dados_Cartao.chave_cartao,                       &
                                                                                                              STR_Dados_Placa.Cod_Placa,                            &
																	                     Ws_codigo_lancamento,                                        &
					                                                                                    Ws_valor_lancamento,                                            &
																	                     Ws_carimbo_lanc_caixa ,                                       &
																	                     Ws_cod_lanc_mo_dia,                                            &
																	                     Wsf_msg_erro_db,                                                   &
																	                     Wsf_cod_erro_db,                                                    &
																	                     Ws_conta_cliente_obs,                                            &
																	                     STR_dados_Contrato.contr_tp_cod_tipo_contrato)              Then
					                                     Return False
									Else
										STR_Dados_placa.lancou_periodo_inicial_II = true
			                       End IF			
                                    /* Lançamento desconto para o periodo inicial II conforme contrato, se houver */
			                      IF str_dados_Contrato.contr_percentual_de_desconto  > 0.00 then  /* Tem desconto *//* Então faço lançamento */
				                         Ws_valor_lancamento          =  (( Ws_Valor_preco_periodo_inicial_ii * str_dados_Contrato.contr_percentual_de_desconto) / 100)
				                         Ws_codigo_lancamento        =  Ws_Cod_lanc_cta_cliente_periodo_inicial_DescTo
				  //
				                          Ws_conta_cliente_obs[3] = "Desconto " + trim(string(str_dados_Contrato.contr_percentual_de_desconto)) +"% S/Periodo Inicial_II"
					
                                                IF Not   FS_ROT_Apur_Efetiva_lancamto(STR_Dados_Contrato.contr_chave_contratos,               &
					                                                                                               STR_Dados_Cartao.Chave_Cartao,                               &
                                                                                                                          STR_Dados_Placa.Cod_Placa,                                    &
																	                                  Ws_codigo_lancamento,                                              &
					                                                                                                 Ws_valor_lancamento,                                                  &
																		                            Ws_carimbo_lanc_caixa ,                                             &
																		                            Ws_cod_lanc_mo_dia,                                                  &
																	                                 Wsf_msg_erro_db,                                                        &
																	                                 Wsf_cod_erro_db,                                                         &
																	                                 Ws_conta_cliente_obs,                                                 &
																		                            STR_dados_Contrato.contr_tp_cod_tipo_contrato)              Then
					                                               Return False
			                                   End IF			
			                            End IF
					    End IF		
			          End If
 
ElseIF   str_dados_Contrato.contr_tp_cod_tipo_preco  =  "2" then   /*Preço Fixo */
	       /* lanca Valor total *//* se houver, lança  o desconto  */
			  string WS_Cod_lanc_CTA_Cliente  
			  string WS_Cod_lanc_CTA_Cliente_DescTo   
			  dec {2} WS_Preco_fixo, Ws_desc_fixo
//	        SELECT PARK_Preco_Fixo.Preco_fixo,
//			           PARK_Preco_Fixo.Cod_lanc_CTA_Cliente, 
//					  PARK_Preco_Fixo.Cod_lanc_CTA_Cliente_DescTo
//			 Into   :WS_Preco_fixo,
//			          :WS_Cod_lanc_CTA_Cliente,
//			          :WS_Cod_lanc_CTA_Cliente_DescTo
//             FROM PARK_Cadastro_Placas INNER JOIN PARK_Preco_Fixo ON 
//				    PARK_Cadastro_Placas.Cod_tipo_vaga   =    PARK_Preco_Fixo.Codigo_Tipo_vaga
//              WHERE  PARK_Preco_Fixo.cod_tipo_contrato  =    :str_dados_Contrato.contr_tp_cod_tipo_contrato  AND 
//				        PARK_Cadastro_Placas.COD_placa     =   :STR_Dados_Placa.Cod_placa
//                 Using SQLCA;
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
         WS_data_pagmto = STR_Dados_Placa.data_entrada
	     
	     
		SELECT  max(Park_vigencia_preco_mensalistas.data_inicio_vigencia_preco)
		     INTO  :Ws_data_Vigencia
           FROM Park_vigencia_preco_mensalistas
       WHERE  Park_vigencia_preco_mensalistas.chave_contratos                    = :STR_Dados_Contrato.contr_chave_contratos  And
	                 Park_vigencia_preco_mensalistas.data_inicio_vigencia_preco    <= : WS_data_pagmto
        Using SQLCA;
        //
		SELECT  max( Park_vigencia_preco_mensalistas.chave_preco_contrato )
		     INTO  :WS_chave_preco_fixo
           FROM Park_vigencia_preco_mensalistas
       WHERE  Park_vigencia_preco_mensalistas.chave_contratos                    = :STR_Dados_Contrato.contr_chave_contratos  And
	                 Park_vigencia_preco_mensalistas.data_inicio_vigencia_preco    =  :Ws_data_Vigencia
        Using SQLCA;	  
		//  
		SELECT Park_vigencia_preco_mensalistas.Vigencia_preco, 
		             Park_vigencia_preco_mensalistas.Cod_lanc_CTA_Cliente, 
		             Park_vigencia_preco_mensalistas.Cod_lanc_CTA_Cliente_DescTo
			 Into   :WS_Preco_fixo,
			          :WS_Cod_lanc_CTA_Cliente,
			          :WS_Cod_lanc_CTA_Cliente_DescTo
          FROM Park_vigencia_preco_mensalistas
       WHERE  Park_vigencia_preco_mensalistas.chave_preco_contrato    =   :WS_chave_preco_fixo
        Using SQLCA;
             wsf_msg_erro_db[1]  =  "Falha BD-fs_apuracao_rotativo_rot01 - CR02"
             wsf_msg_erro_db[2]  =   SQLCA.SQLERRTEXT  
             wsf_cod_erro_db       =   SQLCA.SQLCODE
             //
         IF  wsf_cod_erro_db <> 0 then 
		    messagebox("falha BD","Não foi lançado o valor na conta cliente " + " ~n "+ &
			                                    wsf_msg_erro_db[1] + "   " + wsf_msg_erro_db[2] )
	         Return false
         End if
	      //	
			 ws_conta_cliente_obs[2] = ws_conta_cliente_obs[2] + " Preço Fixo " 
			 Ws_codigo_lancamento  = WS_Cod_lanc_CTA_Cliente
			 ws_valor_lancamento    = WS_Preco_fixo  
			
			  IF Not   FS_ROT_Apur_Efetiva_lancamto(     STR_Dados_Contrato.contr_chave_contratos,               &
					                                                          STR_Dados_Cartao.Chave_cartao,                               &
                                                                                 STR_Dados_Placa.Cod_placa,                                    &
																	    Ws_codigo_lancamento,                                             &
					                                                          ws_valor_lancamento,                                                 &
																		ws_carimbo_lanc_caixa ,                                            &
																		ws_cod_lanc_mo_dia,                                                 &
																	    wsf_msg_erro_db,                                                       &
																	    wsf_cod_erro_db,                                                        &
																	    ws_conta_cliente_obs,                                                 &
																		STR_dados_Contrato.contr_tp_cod_tipo_contrato)        Then
					Return False
			  End IF			
             /* Lançamento desconto conforme contrato, se houver */
				  IF str_dados_Contrato.contr_percentual_de_desconto  > 0.00 then  /* Tem desconto *//* Então faço lançamento */
				      Ws_desc_fixo          = (( WS_Preco_fixo * str_dados_Contrato.contr_percentual_de_desconto) / 100)
				      Ws_codigo_lancamento       = WS_Cod_lanc_CTA_Cliente_DescTo
				  //
				      ws_conta_cliente_obs[3] = trim(string(str_dados_Contrato.contr_percentual_de_desconto))+"% Preço Fixo "
					  ws_valor_lancamento =  Ws_desc_fixo
						
					  IF Not   FS_ROT_Apur_Efetiva_lancamto(STR_Dados_Contrato.contr_chave_contratos,            &
					                                                              STR_Dados_Cartao.Chave_cartao,                            &
                                                                                    STR_Dados_Placa.Cod_Placa,                                  &
																	        Ws_codigo_lancamento,                                           &
					                                                              ws_valor_lancamento,                                              &
																		    ws_carimbo_lanc_caixa ,                                         &
																		    ws_cod_lanc_mo_dia,                                             &
																	         wsf_msg_erro_db,                                                   &
																	         wsf_cod_erro_db,                                                    &
																	         ws_conta_cliente_obs,                                            &
																			STR_dados_Contrato.contr_tp_cod_tipo_contrato )    Then
					          Return False
			           End IF			
				End IF

End IF

Return true
end function

public function boolean fs_apuracao_rotativo_rot02 (ref string wsf_msg_erro_db[], integer wsf_cod_erro_db);/*  apurar e fazer o lancamento na conta cliente  em movimento de saida   Lançar o periodo final  o desconto se houver   
     procedimentos diferentes para preço fixo e variavel  verificação do tipo de preço 1 pgmt hora e 2 preço fixo  
     sendo preço fixo nao lançar nada na conta cliente  */
/* Recuperar a data da entrada e usar a data atual como data fim */
//////////////////////////////////////
datetime WS_dta_entrada
datetime WS_dta_saida
long ws_qtd_minutos
string    WS_Conta_Cliente_Obs[], Ws_Cod_lanc_cta_cliente_periodo_inicial_ii
long      ws_carimbo_lanc_caixa
long     ws_cod_lanc_mo_dia
Long    WS_chave_preco_variavel
datetime Ws_data_Vigencia
datetime WS_data_pagmto
////////////////////////////////////////
   WS_conta_cliente_obs[1] = "Lançamento automático feito pelo Sistema"
   WS_conta_cliente_obs[2] = "Conforme Contrato"
   //WS_dta_saida =  datetime(Today() , now())
   ws_carimbo_lanc_caixa = 000
   ws_cod_lanc_mo_dia     = 000
// CR01 //
//Messagebox("Dados" ,  string(STR_Dados_Placa.data_entrada, "DD/MM/YYYY hh:MM:ss") +" ~n " + &
//                                   string(STR_Dados_Placa.data_saida, "DD/MM/YYYY hh:MM:ss") +" ~n " + &
//							   string(STR_Dados_Placa.QTD_Minutos))
//
//SELECT  PARK_Movimento_Diario.data_operacao,
//              PARK_Movimento_Diario.data_operacao_saida,
//		     PARK_Movimento_Diario.tempo_permanencia_minutos
//     into  :STR_Dados_Placa.Data_entrada,
//	        :STR_Dados_Placa.Data_saida,
//		   :STR_Dados_Placa.QTD_Minutos	 
// FROM   PARK_Movimento_Diario
//WHERE  chave_movimento_diario = :STR_Dados_Cartao.chave_movimento_diario
//USING SQLCA;
//
/*
SELECT  PARK_Movimento_Diario.data_operacao,
              PARK_Movimento_Diario.data_operacao_saida,
		     PARK_Movimento_Diario.tempo_permanencia_minutos
     into  :STR_Dados_Placa.Data_entrada,
	        :STR_Dados_Placa.Data_saida,
		   :STR_Dados_Placa.QTD_Minutos	 
 FROM   PARK_Movimento_Diario
WHERE  chave_movimento_diario = ( Select PARK_Cadastro_cartoes.chave_movimento_diario
                                                       from PARK_Cadastro_cartoes
												 where PARK_Cadastro_cartoes.chave_contratos   =   :STR_Dados_Contrato.contr_chave_contratos and
												           PARK_Cadastro_cartoes.CHave_cartao       =   :STR_Dados_Cartao.Chave_cartao    and
														  PARK_Cadastro_cartoes.COD_placa           =  :STR_Dados_Placa.Cod_placa      and
														  PARK_Cadastro_cartoes.status_cartao       =    1 )
USING SQLCA;
*/
SELECT  PARK_Movimento_Diario.data_operacao,
              PARK_Movimento_Diario.data_operacao_saida,
		     PARK_Movimento_Diario.tempo_permanencia_minutos
     into  :STR_Dados_Placa.Data_entrada,
	        :STR_Dados_Placa.Data_saida,
		   :STR_Dados_Placa.QTD_Minutos	 
 FROM   PARK_Movimento_Diario
WHERE  chave_movimento_diario = :STR_dados_Cartao.chave_movimento_diario
USING SQLCA;
      wsf_msg_erro_db[1]  =  "Falha BD-fs_apuracao_rotativo_rot02 - CR01"
      wsf_msg_erro_db[2]  =   SQLCA.SQLERRTEXT  
      wsf_cod_erro_db       =   SQLCA.SQLCODE
      //
      IF  wsf_cod_erro_db <> 0 then 
		 messagebox("falha BD - PARK_Movimento_Diario","Não foi lançado o valor na conta cliente" + "~n  " + wsf_msg_erro_db[1] + "~n " + & 
		                           SQLCA.SQLERRTEXT + "~n " +  string(wsf_cod_erro_db))
	      Return false
      End if
///////////
//  str_dados_Contratos.CONTr_Data_entrada = WS_dta_entrada
//  IF  not FS_Qtd_minutos(WS_dta_entrada,  WS_dta_saida, wsf_msg_erro_db, wsf_cod_erro_db, ws_qtd_minutos)   then
//	  messagebox("falha BD","Não foi lançado o valor na conta cliente")
//	  Return false
//  End IF	
////	
 /* CR 02 */ /* verificação do tipo de preço */
   	  string       Ws_codigo_lancamento
 IF  STR_Dados_Contrato.contr_tp_cod_tipo_preco  =  "1"  then   /* Preço por hora */
      /* Apurar a fração  *//* se houver, lança desconto sobre a fração */
	  string       WS_query_lancamento
       string       Ws_Cod_lanc_cta_cliente_periodo_inicial	
	  string       Ws_Cod_lanc_cta_cliente_Fracao
	  string       Ws_Cod_lanc_cta_cliente_periodo_inicial_DescTo
	   string       Ws_Cod_lanc_cta_cliente_Fracao_DescTo

        Int           Ws_QTD_Minutos_periodo_Inicial
	   INT         Ws_QTD_Minutos_periodo_Inicial_ii
	    Int	        Ws_QTD_minutos_fracao
	    Int           ws_sequencia_lancamento
        Dec {2}   Ws_Valor_preco_periodo_inicial
	   Dec {2}    Ws_Valor_preco_periodo_inicial_ii
	   Dec {2}   Ws_Valor_preco_Fracao
	   dec {2}  ws_valor_lancamento
	   Datetime ws_dta_lancamento
	   //
////////////////////////////////////////////////////////////////////////////////////////////////////////////
// WS_data_pagmto  =  datetime(today(), time( "00:00:01" ))
WS_data_pagmto  = STR_Dados_Placa.data_entrada
 Setnull( Ws_data_Vigencia )
 SELECT  MAX(data_inicio_vigencia_preco_variavel)	 
      INTO  :Ws_data_Vigencia
	FROM 	PARK_Preco_Variavel_Hora 	
  WHERE 	PARK_Preco_Variavel_Hora.Codigo_Tipo_vaga                                  =    :STR_Dados_Placa.cod_tipo_vaga	                             AND
			     PARK_Preco_Variavel_Hora.cod_tipo_contrato                                     =    :STR_dados_Contrato.contr_tp_cod_tipo_contrato       AND
				PARK_Preco_Variavel_Hora.data_inicio_vigencia_preco_variavel    <=   :WS_data_pagmto
       Using SQLCA;
 
 SELECT  PARK_Preco_Variavel_Hora.Chave_preco_variavel_hora
       INTO    :WS_chave_preco_variavel
	FROM 	PARK_Preco_Variavel_Hora 	
  WHERE 	PARK_Preco_Variavel_Hora.Codigo_Tipo_vaga                                  =    :STR_Dados_Placa.cod_tipo_vaga	                             AND
			     PARK_Preco_Variavel_Hora.cod_tipo_contrato                                     =    :STR_dados_Contrato.contr_tp_cod_tipo_contrato       AND
				PARK_Preco_Variavel_Hora.data_inicio_vigencia_preco_variavel     =   :Ws_data_Vigencia
       Using SQLCA;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////		
        SELECT  PARK_Preco_Variavel_Hora.QTD_Minutos_periodo_Inicial, 
		               PARK_Preco_Variavel_Hora.QTD_Minutos_periodo_Inicial_ii, 
	                    PARK_Preco_Variavel_Hora.QTD_minutos_fracao, 
	                    PARK_Preco_Variavel_Hora.Valor_preco_periodo_inicial, 
				    PARK_Preco_Variavel_Hora.Valor_preco_periodo_inicial_ii, 			
	                    PARK_Preco_Variavel_Hora.Valor_preco_Fracao,
				    PARK_Preco_Variavel_Hora.Cod_lanc_cta_cliente_periodo_inicial	,
				    PARK_Preco_Variavel_Hora.Cod_lanc_cta_cliente_periodo_inicial_ii	, 
				    PARK_Preco_Variavel_Hora.Cod_lanc_cta_cliente_Fracao,
				    PARK_Preco_Variavel_Hora.Cod_lanc_cta_cliente_periodo_inicial_DescTo,
				    PARK_Preco_Variavel_Hora.Cod_lanc_cta_cliente_Fracao_DescTo
        INTO  :Ws_QTD_Minutos_periodo_Inicial,
		        :Ws_QTD_Minutos_periodo_Inicial_ii,
	 	        :Ws_QTD_minutos_fracao,
                   :Ws_Valor_preco_periodo_inicial,
			    :Ws_Valor_preco_periodo_inicial_ii,
	                :Ws_Valor_preco_Fracao,
				:Ws_Cod_lanc_cta_cliente_periodo_inicial,	
				:Ws_Cod_lanc_cta_cliente_periodo_inicial_ii,
				:Ws_Cod_lanc_cta_cliente_Fracao,
				:Ws_Cod_lanc_cta_cliente_periodo_inicial_DescTo,
                  :Ws_Cod_lanc_cta_cliente_Fracao_DescTo
	FROM 	PARK_Preco_Variavel_Hora 				
	WHERE 	PARK_Preco_Variavel_Hora.Chave_preco_variavel_hora   =  :WS_chave_preco_variavel
       Using SQLCA;
      wsf_msg_erro_db[1]  =  "Falha BD-fs_apuracao_rotativo_rot02 - CR02"
      wsf_msg_erro_db[2]  =   SQLCA.SQLERRTEXT  
      wsf_cod_erro_db       =   SQLCA.SQLCODE
      //
      IF  wsf_cod_erro_db <> 0 then 
		 messagebox("falha BD - PARK_Preco_Variavel_Hora ","Não foi lançado o valor na conta cliente")
	      Return false
      End if
	 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	 /* Calculo do valor fracao */
	              int  ws_qtd_fracao
				 int ws_qtd_expurdado_qtd_perio_inicial
				 //
				 IF STR_Dados_Placa.QTD_Minutos >  ( Ws_QTD_Minutos_periodo_Inicial +  Ws_QTD_Minutos_periodo_Inicial_II) Then  /* sobra residuo - então gera fracao */
					  ws_qtd_expurdado_qtd_perio_inicial = (STR_Dados_Placa.qtd_minutos - (Ws_QTD_Minutos_periodo_Inicial + Ws_QTD_Minutos_periodo_Inicial_II ))
					  IF ws_qtd_expurdado_qtd_perio_inicial < 0 then
						    ws_qtd_expurdado_qtd_perio_inicial  = 0
					  End if	
					  IF ws_qtd_expurdado_qtd_perio_inicial  <=  Ws_QTD_minutos_fracao Then
						      ws_qtd_fracao = 1
					      Else
						       ws_qtd_fracao = ( ws_qtd_expurdado_qtd_perio_inicial  /  Ws_QTD_minutos_fracao )
                                       IF mod  ( ws_qtd_expurdado_qtd_perio_inicial  ,  Ws_QTD_minutos_fracao  )  >  0  then
								    ws_qtd_fracao ++
							  End IF
 			             End if
				   ElseIF STR_Dados_Placa.qtd_minutos <=  (Ws_QTD_Minutos_periodo_Inicial  +  Ws_QTD_Minutos_periodo_Inicial_II ) Then  /*não sobra tempo para fracao */
					       ws_qtd_fracao = 0
				 End IF
              /* Lançamento Fracao, se houver */
				  IF ws_qtd_fracao  > 0 Then 
					        Ws_valor_lancamento         =   ( Ws_Valor_preco_Fracao * ws_qtd_fracao)
						   Ws_codigo_lancamento     =   Ws_Cod_lanc_cta_cliente_Fracao
						   WS_conta_cliente_obs[3]   =   trim(string(ws_qtd_fracao)) + " x Valor da Fração -> " + trim(string(Ws_Valor_preco_Fracao))
						   Ws_cod_lanc_mo_dia         =   STR_dados_Cartao.chave_movimento_diario
						   IF Not   FS_ROT_Apur_Efetiva_lancamto(STR_Dados_Contrato.contr_chave_contratos,               &
					                                                                                 STR_Dados_Cartao.Chave_Cartao,                              &
                                                                                                            STR_Dados_Placa.Cod_Placa,                                   &
																	                   Ws_codigo_lancamento,                                            &
					                                                                                  ws_valor_lancamento,                                                &
																			         ws_carimbo_lanc_caixa,                                             &
																			         ws_cod_lanc_mo_dia,                                                 &
																	                   wsf_msg_erro_db,                                                      &
																	                   wsf_cod_erro_db,                                                       &
																	                   ws_conta_cliente_obs,                                                &
																				    STR_dados_Contrato.contr_tp_cod_tipo_contrato	 )   Then
					                 Return False
			                   End IF			
				End IF
				  
             /* Lançamento desconto conforme contrato, se houver */ /*    Não ha desconto para a fracao */
//				 IF str_dados_Contrato.contr_percentual_de_desconto  > 0.00 then  /* Tem desconto *//* Então faço lançamento */
//				     ws_valor_lancamento          = (( ws_valor_lancamento * str_dados_Contrato.contr_percentual_de_desconto) / 100)
//					 Ws_codigo_lancamento   =   Ws_Cod_lanc_cta_cliente_Fracao_DescTo
//				  //
//				     WS_conta_cliente_obs[3] = "Desc >> " + trim(string(str_dados_Contrato.contr_percentual_de_desconto)) + "% sobre Fração >> " + &
//					                                        trim(string(ws_qtd_fracao)) + " x Valor da Fração -> " + trim(string(Ws_Valor_preco_Fracao))
//																		 
//						  IF Not   FS_ROT_Apur_Efetiva_lancamto(STR_Dados_Contrato.contr_chave_contratos,               &
//					                                                                  STR_Dados_Cartao.Chave_Cartao,                               &
//                                                                                         STR_Dados_Placa.Cod_Placa,                                    &
//																	            Ws_codigo_lancamento,                                               &
//					                                                                  ws_valor_lancamento,                                                  &
//																		        ws_carimbo_lanc_caixa,                                               &	
//																		        ws_cod_lanc_mo_dia,                                                  &
//																	             wsf_msg_erro_db,                                                       &
//																	             wsf_cod_erro_db,                                                        &
//																	             ws_conta_cliente_obs,                                                &
//																			    STR_dados_Contrato.contr_tp_cod_tipo_contrato)              Then
//					            Return False
//			               End IF			
// 		           End IF
 
ElseIF   str_dados_Contrato.contr_tp_cod_tipo_preco  =  "2" then   /*Preço Fixo */

             /* Não há lançamento de fração para preço fixo */


End IF


Return true
end function

public function boolean fs_rot_apur_recupera_saldo_placa (ref decimal wsf_saldo_anterior, ref string wsf_deb_cred, ref string wsf_msg_erro_db[], ref integer wsf_cod_erro_db);/*   fs_rot_apur_recupera_saldo_placa( wsf_msg_erro_db,   wsf_cod_erro_db)  */
dec {2}  ws_Total_credito
dec {2}  ws_total_debito
string     Ws_codigo_lancamento
dec {2}  ws_valor_lancamento
long       ws_carimbo_lanc_caixa
string     ws_conta_cliente_obs[]
long       ws_cod_lanc_diario_anterior
Long       ws_cod_lanc_mo_dia
//  
ws_Total_credito = 0.00
 ws_cod_lanc_mo_dia = 000
////// Rotina 01 apura o saldo a debito e a crédito //////////
//SELECT Sum(PARK_Conta_cliente.Valor_lancamento) AS totoal_Valor_lancamento 
//    into   :ws_Total_credito
//FROM PARK_Conta_cliente INNER JOIN PARK_Conta_cliente_codigos_lancamentos ON 
//          PARK_Conta_cliente.Cod_lancamento = PARK_Conta_cliente_codigos_lancamentos.Cod_lancamento
//GROUP BY PARK_Conta_cliente.COD_placa, PARK_Conta_cliente_codigos_lancamentos.Cod_DEBITO_CREDITO
//HAVING  PARK_Conta_cliente.COD_placa =    :STR_Dados_Placa.Cod_Placa   AND 
//              PARK_Conta_cliente_codigos_lancamentos.Cod_DEBITO_CREDITO =  'C' 
//	Using SQLCA;	 

SELECT Sum(PARK_Conta_cliente.Valor_lancamento) AS totoal_Valor_lancamento 
     INTO   :ws_Total_credito
FROM PARK_Conta_cliente INNER JOIN PARK_Conta_cliente_codigos_lancamentos ON 
          PARK_Conta_cliente.Cod_lancamento = PARK_Conta_cliente_codigos_lancamentos.Cod_lancamento
WHERE  PARK_Conta_cliente.COD_placa                                                       =   :STR_Dados_Placa.Cod_Placa   AND
              PARK_Conta_cliente.chave_caixa_lancamentos                                  =   0    and
              PARK_Conta_cliente_codigos_lancamentos.Cod_DEBITO_CREDITO   =   'C' 
GROUP BY PARK_Conta_cliente.COD_placa, PARK_Conta_cliente_codigos_lancamentos.Cod_DEBITO_CREDITO
	Using SQLCA;	 
//
      wsf_msg_erro_db[1]  =  "Falha BD-fs_apuracao_rotativo_rot01 - CR01"
      wsf_msg_erro_db[2]  =   SQLCA.SQLERRTEXT  
      wsf_cod_erro_db       =   SQLCA.SQLCODE
      //
      IF  wsf_cod_erro_db <> 0   Then
		 IF wsf_cod_erro_db = 100 then 
			ws_Total_credito = 0
		 Else
		       messagebox("falha BD1",SQLCA.SQLERRTEXT)
	     End IF
      End if	
//	
//
//
//SELECT Sum(PARK_Conta_cliente.Valor_lancamento) AS totoal_Valor_lancamento 
//    into   :ws_total_debito
//FROM PARK_Conta_cliente INNER JOIN PARK_Conta_cliente_codigos_lancamentos ON 
//          PARK_Conta_cliente.Cod_lancamento = PARK_Conta_cliente_codigos_lancamentos.Cod_lancamento
//GROUP BY PARK_Conta_cliente.COD_placa, PARK_Conta_cliente_codigos_lancamentos.Cod_DEBITO_CREDITO
//HAVING  PARK_Conta_cliente.COD_placa =    :STR_Dados_Placa.Cod_Placa AND 
//             PARK_Conta_cliente_codigos_lancamentos.Cod_DEBITO_CREDITO = 'D' 
//	Using SQLCA;	 
//
SELECT Sum(PARK_Conta_cliente.Valor_lancamento) AS totoal_Valor_lancamento 
     INTO   :ws_total_debito
FROM PARK_Conta_cliente INNER JOIN PARK_Conta_cliente_codigos_lancamentos ON 
          PARK_Conta_cliente.Cod_lancamento = PARK_Conta_cliente_codigos_lancamentos.Cod_lancamento
WHERE  PARK_Conta_cliente.COD_placa                                                       =   :STR_Dados_Placa.Cod_Placa   AND
              PARK_Conta_cliente.chave_caixa_lancamentos                                  =    0    and
              PARK_Conta_cliente_codigos_lancamentos.Cod_DEBITO_CREDITO    =   'D' 
GROUP BY PARK_Conta_cliente.COD_placa, 
                  PARK_Conta_cliente_codigos_lancamentos.Cod_DEBITO_CREDITO
	Using SQLCA;	 
//
      wsf_msg_erro_db[1]  =  "Falha BD-fs_apuracao_rotativo_rot01 - CR01"
      wsf_msg_erro_db[2]  =   SQLCA.SQLERRTEXT  
      wsf_cod_erro_db       =   SQLCA.SQLCODE
      //
      IF  wsf_cod_erro_db <> 0   Then
		 IF wsf_cod_erro_db = 100 then 
			ws_total_debito = 0
		 Else
		       messagebox("falha BD1",SQLCA.SQLERRTEXT)
	     End IF
      End if	
//

If ws_total_debito  <  ws_Total_credito then
	wsf_deb_cred = "C"
	wsf_saldo_anterior = (ws_Total_credito - ws_total_debito)
elseIf ws_total_debito  >  ws_Total_credito then
	wsf_deb_cred = "D"
	wsf_saldo_anterior = ( ws_total_debito - ws_Total_credito )
elseIf ws_total_debito  =  ws_Total_credito then	
	wsf_deb_cred = "C"
	wsf_saldo_anterior = 0.00
END IF


//////////// Rotina 02 ////////////////////////
/* verifica o saldo e faz a rotina de lançamentos conforme saldos */
  IF wsf_saldo_anterior > 00.00 then    /* Tem residuo  */
	                                                    /*  Pega o ultimo lancamento ao caixa e faz um lancamento cruzado para zerar a conta antiga */
												   /* Faz o lancamento na nova conta */ 
	               long    ws_contrato_antigo
				  string ws_cartao_antigo
				  int      ws_seq_antiga
				  long   ws_caixa_lanc_antigo
                    long   ws_CHAVE_ANTIGA
				  SELECT  PARK_Conta_cliente.chave_contratos, 
							  PARK_Conta_cliente.CHave_cartao, 
							  PARK_Conta_cliente.seq_contrato_cartao_placa, 
							  PARK_Conta_cliente.chave_caixa_lancamentos,
							  PARK_Conta_cliente.chave_movimento_diario
					INTO    :ws_contrato_antigo,
							  :ws_cartao_antigo,
							  :ws_seq_antiga,
							  :ws_caixa_lanc_antigo,
							  :ws_cod_lanc_diario_anterior
                       FROM PARK_Conta_cliente 
                     WHERE PARK_Conta_cliente.Chave_conta_cliente  = (  SELECT  MAX( PARK_Conta_cliente.Chave_conta_cliente ) 
							                                                                     FROM    PARK_Conta_cliente
																						  WHERE PARK_Conta_cliente.COD_placa = :STR_Dados_Placa.Cod_Placa and
																						             PARK_Conta_cliente.Chave_conta_cliente <>  (							  
							                                                                                   SELECT  MAX( PARK_Conta_cliente.Chave_conta_cliente ) 
							                                                                                     FROM    PARK_Conta_cliente
							                                                                                    WHERE  PARK_Conta_cliente.COD_placa = :STR_Dados_Placa.Cod_Placa  ))
				  USING SQLCA;
				  
//				  chave_movimento_diario
				  
				//
				 wsf_msg_erro_db[1]  =  "Falha BD-fs_apuracao_rotativo_rot01 - CR01"
                   wsf_msg_erro_db[2]  =   SQLCA.SQLERRTEXT  
                   wsf_cod_erro_db       =   SQLCA.SQLCODE
                  //
                  IF  wsf_cod_erro_db <> 0 then 
		             messagebox("falha BD",SQLCA.SQLERRTEXT)
                  End if	
		/* Preparar para efetivar o lançamento */
		        /* lancamento da contra partida */
		                 IF wsf_deb_cred = "D"  Then
		                      Ws_codigo_lancamento   =  "22"
						  elseIF wsf_deb_cred = "C" then
							     Ws_codigo_lancamento   =  "23"
					    End If
						 ws_cod_lanc_mo_dia     =   ws_cod_lanc_diario_anterior
		                  ws_valor_lancamento      =   wsf_saldo_anterior
		                  ws_carimbo_lanc_caixa   =   ws_caixa_lanc_antigo
		                  ws_conta_cliente_obs[1]  =  "Lançamento automático pelo sistema"
						ws_conta_cliente_obs[2]  =  "Serve para contra-partida na conta cliente"		
						ws_conta_cliente_obs[2]  =  "Recuperação de saldo dos periodos anteriores"	
		                 IF Not   FS_ROT_Apur_Efetiva_lancamto(ws_contrato_antigo,                                                 &
					                                                                ws_cartao_antigo,                                                   &
                                                                                      STR_Dados_Placa.Cod_Placa,                                 &
																	          Ws_codigo_lancamento,                                          &
					                                                                ws_valor_lancamento,                                              &
																	          ws_carimbo_lanc_caixa ,                                         &
																			 ws_cod_lanc_mo_dia,                                              &
																	          wsf_msg_erro_db,                                                    &
																	          wsf_cod_erro_db,                                                     &
																	          ws_conta_cliente_obs,                                              &
																			 STR_dados_Contrato.contr_tp_cod_tipo_contrato)     Then
					         Return False
			              End IF	
		        /* lancamento do saldo na nova chave -> [contrato / cartão / placa] */
		                 IF wsf_deb_cred = "D"  Then
		                      Ws_codigo_lancamento   =  "20"
						  elseIF wsf_deb_cred = "C" then
							     Ws_codigo_lancamento   =  "19"
					    End If
		                  ws_valor_lancamento      =   wsf_saldo_anterior
		                  ws_carimbo_lanc_caixa   =   000
						ws_cod_lanc_mo_dia      =   000
		                  ws_conta_cliente_obs[1]  =  "Lançamento automático pelo sistema"
						ws_conta_cliente_obs[2]  =  "Serve trazer o saldo para o novo serviço"		
		                 IF Not   FS_ROT_Apur_Efetiva_lancamto(STR_Dados_Contrato.contr_chave_contratos,           &
					                                                               STR_Dados_Cartao.Chave_Cartao,                           &
                                                                                      STR_Dados_Placa.Cod_Placa,                                & 
																	          Ws_codigo_lancamento,                                         &
					                                                                ws_valor_lancamento,                                             &
																	          ws_carimbo_lanc_caixa ,                                        &
																			 ws_cod_lanc_mo_dia,                                             &
																	          wsf_msg_erro_db,                                                   &
																	          wsf_cod_erro_db,                                                    &
																	          ws_conta_cliente_obs,                                             &
																			 STR_dados_Contrato.contr_tp_cod_tipo_contrato)     Then
					         Return False
			              End IF	

  END IF																											                         
Return true 
		 
		 

end function

protected function boolean fs_recupera_rotativo_entrada_saidax (ref long wsf_num_contrato, ref string wsf_cod_cartao, ref string wsf_cod_placa, ref datetime wsf_data_entrada, ref datetime wsf_data_saida, ref string wsf_msg_erro_db[], ref integer wsf_cod_erro_db);/*  
fs_recupera_rotativo_entrada_saida
    wsF_Num_contrato
    wsF_cod_cartao
    WSF_cod_placa
    wsf_data_entrada
    wsf_data_saida
    wsf_msg_erro_db[ ]
    wsf_cod_erro_db
*/
long   ws_chave_movimento
long   ws_chave_mov_diario_entrada
long   ws_chave_mov_diario_saida
string ws_tipo_operacao
string ws_chave_critica
datetime ws_data_saida
/*
     Tratando-se de uma operação do rotativo, e estando nesta operação uma saida,
     pego na tabela de cartoes o ultimo movimento que é de saida e dai pego o registro da 
     entrada  
     Para o rotativo o cartão ainda está atribuido á placa e para os mensalistas tambem, já 
	 que o cartão só é liberado na emissão da fatura para os rotativos e no termino do contrato
	 para os mensalistas <> então a recuperação do movimento deverá ser pelo cadastro dos
	 cartões.
*/
Select  PARK_Cadastro_cartoes.chave_movimento_diario
  INTO  :ws_chave_movimento 
 from   PARK_Cadastro_cartoes
 where PARK_Cadastro_cartoes.CHave_cartao   =   :wsf_cod_cartao    and
           PARK_Cadastro_cartoes.COD_placa       =   :wsf_cod_placa      and
		  PARK_Cadastro_cartoes.status_cartao    =   1
	USING SQLCA;
      wsf_msg_erro_db[1]  =  "Falha na leitura da tabela PARK_Cadastro_cartoes"
      wsf_msg_erro_db[2]  =   SQLCA.SQLERRTEXT  
      wsf_cod_erro_db       =   SQLCA.SQLCODE
      //
      IF  wsf_cod_erro_db <> 0 then 
           return false
	 End IF
//
////////////////////////////////////////
//
SELECT 	data_operacao,
			data_operacao_saida
 INTO     :wsf_data_entrada,
		    :wsf_data_saida
FROM    PARK_Movimento_Diario 
 WHERE   chave_movimento_diario = :ws_chave_movimento
USING SQLCA;
 wsf_msg_erro_db[1]  =  "Falha na leitura da tabela PARK_Movimento_Diario "
 wsf_msg_erro_db[2]  =   SQLCA.SQLERRTEXT  
 wsf_cod_erro_db       =   SQLCA.SQLCODE
 //
    IF  wsf_cod_erro_db <> 0 then 
		Return False
	End If
///
//
return true	
				
//				
//				( Select max(chave_movimento_diario)
//                                                                       from PARK_Movimento_Diario
//												               where PARK_Movimento_Diario.chave_contratos   =  :wsF_Num_contrato  and
//												                         PARK_Movimento_Diario.CHave_cartao       =  :wsF_cod_cartao      and
//														                PARK_Movimento_Diario.placa_veiculo        =  :WSF_cod_placa      and
//														                PARK_Movimento_Diario.tipo_operacao       =   '2')
//			USING SQLCA;
//              wsf_msg_erro_db[1]  =  "Falha na leitura da tabela PARK_Movimento_Diario "
//              wsf_msg_erro_db[2]  =   SQLCA.SQLERRTEXT  
//              wsf_cod_erro_db       =   SQLCA.SQLCODE
//      //
//              IF  wsf_cod_erro_db <> 0 then 
//		          Return False
//				Else		 
//					 SELECT  PARK_Movimento_Diario.data_operacao
//       	                 INTO  :wsf_data_entrada
//                         FROM   PARK_Movimento_Diario 
//	                   WHERE   chave_movimento_diario = :ws_chave_mov_diario_entrada
//					  USING  SQLCA;
//                                 wsf_msg_erro_db[1]  =  "Falha na leitura da tabela PARK_Movimento_Diario "
//                                 wsf_msg_erro_db[2]  =   SQLCA.SQLERRTEXT  
//                                 wsf_cod_erro_db       =   SQLCA.SQLCODE
//                                  //
//                               IF wsf_cod_erro_db <> 0 then 
//                                   Return false
//					         End If
//				 
//			End IF		 
//					 
//elseIF ws_chave_critica = "2"  then					 
//					 
//			      SELECT   PARK_Movimento_Diario.data_operacao
//	                INTO     :wsf_data_entrada
//                   FROM     PARK_Movimento_Diario 
//	             WHERE   chave_movimento_diario = ( Select max(chave_movimento_diario)
//                                                                       from PARK_Movimento_Diario
//												               where PARK_Movimento_Diario.chave_contratos   =  :wsF_Num_contrato  and
//												                         PARK_Movimento_Diario.CHave_cartao       =  :wsF_cod_cartao      and
//														                PARK_Movimento_Diario.placa_veiculo        =  :WSF_cod_placa      and
//														                PARK_Movimento_Diario.tipo_operacao       =   '1')
//			        USING SQLCA;
//                           wsf_msg_erro_db[1]  =  "Falha na leitura da tabela PARK_Movimento_Diario "
//                          wsf_msg_erro_db[2]  =   SQLCA.SQLERRTEXT  
//                          wsf_cod_erro_db       =   SQLCA.SQLCODE
//      //
//              IF  wsf_cod_erro_db <> 0 then 
//		           Return false
//				End If
//		
//		wsf_data_saida  = datetime(today(), now())
//		
//End IF		
//		
	
//					 
//					 INNER JOIN PARK_Cadastro_cartoes ON 
//	           PARK_Movimento_Diario.chave_movimento_diario = PARK_Cadastro_cartoes.chave_movimento_diario
//    WHERE  PARK_Cadastro_cartoes.CHave_cartao = :wsf_cod_cartao  
//	USING SQLCA;
//		
//		
//		
//		
//		
//		
//		
//		
//		
//		
//		
//		
//		
//		
//		
//		
//		
//      If ws_tipo_operacao = "1" then 
//		   wsf_msg_erro_db[1]  =  "Falha Lógica, Esta operação ainda não teve a saída."
//            wsf_msg_erro_db[2]  =    ""
//		   Return False
//		Else		
//             ws_chave_mov_diario_entrada   = ws_chave_movimento	
//	  End If
// 
// 
// 
// 
// 
// 
//
//	SELECT PARK_Movimento_Diario.chave_movimento_diario_ent,
//	            PARK_Movimento_Diario.tipo_operacao
//	  INTO  :ws_chave_movimento,
//	           :ws_tipo_operacao
//    FROM   PARK_Movimento_Diario INNER JOIN PARK_Cadastro_cartoes ON 
//	           PARK_Movimento_Diario.chave_movimento_diario = PARK_Cadastro_cartoes.chave_movimento_diario
//    WHERE  PARK_Cadastro_cartoes.CHave_cartao = :wsf_cod_cartao  
//	USING SQLCA;
//      wsf_msg_erro_db[1]  =  "Falha na leitura da tabela PARK_Movimento_Diario - entrada"
//      wsf_msg_erro_db[2]  =   SQLCA.SQLERRTEXT  
//      wsf_cod_erro_db       =   SQLCA.SQLCODE
//      //
//      IF  wsf_cod_erro_db <> 0 then 
//		 
//          return false
//      End if
//      If ws_tipo_operacao = "1" then 
//		   wsf_msg_erro_db[1]  =  "Falha Lógica, Esta operação ainda não teve a saída."
//            wsf_msg_erro_db[2]  =    ""
//		   Return False
//		Else		
//             ws_chave_mov_diario_entrada   = ws_chave_movimento	
//	  End If
//	 
//	 
//	 
//// apura a maior data da entrada //
//
////
////SELECT  PARK_Movimento_Diario.data_operacao,
////             PARK_Movimento_Diario.chave_movimento_diario
////     into  :wsf_data_entrada ,
//////	        :ws_chave_movimento_diario
//// FROM   PARK_Movimento_Diario
////WHERE  chave_movimento_diario = ( Select max(chave_movimento_diario)
////                                                       from PARK_Movimento_Diario
////												 where PARK_Movimento_Diario.chave_contratos   =  :wsF_Num_contrato  and
////												           PARK_Movimento_Diario.CHave_cartao       =  :wsF_cod_cartao      and
////														  PARK_Movimento_Diario.placa_veiculo        =  :WSF_cod_placa      and
////														  PARK_Movimento_Diario.tipo_operacao       =   '1')
////USING SQLCA;
////      wsf_msg_erro_db[1]  =  "Falha na leitura da tabela PARK_Movimento_Diario - entrada"
////      wsf_msg_erro_db[2]  =   SQLCA.SQLERRTEXT  
////      wsf_cod_erro_db       =   SQLCA.SQLCODE
////      //
////      IF  wsf_cod_erro_db <> 0 then 
////		  wsf_data_entrada = datetime("01/01/1900 00:00:01")
////          return false
////      End if
//// apura a maior data da saida //		
////SELECT  PARK_Movimento_Diario.data_operacao
////     into  :wsf_data_saida
//// FROM   PARK_Movimento_Diario
////WHERE  chave_movimento_diario = ( Select max(chave_movimento_diario)
////                                                       from PARK_Movimento_Diario
////												 where PARK_Movimento_Diario.chave_contratos   =  :str_dados_Contratos.CONTr_Num_contrato and
////												           PARK_Movimento_Diario.CHave_cartao       =  :str_dados_Contratos.CONTr_Cod_Cartao    and
////														  PARK_Movimento_Diario.placa_veiculo        =  :str_dados_Contratos.CONTr_Cod_placa      and
////														  PARK_Movimento_Diario.tipo_operacao       =   '2'                                                           and
////														  PARK_Movimento_Diario.chave_movimento_diario >  :ws_chave_movimento_diario)
////USING SQLCA;
////      wsf_msg_erro_db[1]  =  "Falha na leitura da tabela PARK_Movimento_Diario - saida"
////      wsf_msg_erro_db[2]  =   SQLCA.SQLERRTEXT  
////      wsf_cod_erro_db       =   SQLCA.SQLCODE
////      //
////      IF  wsf_cod_erro_db <> 0 then 
////		  wsf_data_saida = datetime(today(), now())
////          return false
////      End if		
/////////////


end function

public function boolean fs_rotina_apuracao (ref string wsf_msg_erro_db[], ref integer wsf_cod_erro_db);/* */
/*  Neste ponto faço os premissas de apuração  */
long WS_Chave_Contrato
long WS_chave_movimento_diario
 
///////////////////
/* CR01 */
/*  teste
Select chave_contratos,
          chave_movimento_diario
Into    :str_dados_Contrato.CONTr_Num_contrato,
          :WS_chave_movimento_diario    
from PARK_Cadastro_cartoes
where CHave_cartao  = :wsF_chave_cartao  And
          COD_placa      = :wsF_COD_placa     And
	      status_cartao  = 1
USING SQLCA;
// 
   wsf_msg_erro_db[1]  =  "Falha BD - FS_Rotina_Apuracao -CR01"
   wsf_msg_erro_db[2]  = SQLCA.SQLERRTEXT  
   wsf_cod_erro_db       =  SQLCA.SQLCODE
 //
IF  wsf_cod_erro_db <> 0 then 
	Return false
End if
str_dados_Contratos.CONTr_Cod_placa   = wsF_COD_placa
str_dados_Contratos.CONTr_Cod_Cartao = wsF_chave_cartao
// CR02 //
SELECT PARK_Contratos.dt_Validade_do_contrato_Fim, 
             PARK_Contratos.Percentual_de_desconto, 
             PARK_Contratos_Tipo.cod_tipo_contrato, 
             PARK_Contratos_Tipo.desc_tipo_contrato, 
             PARK_Contratos_Tipo.Atribuido_pelo_operador, 
             PARK_Contratos_Tipo.Identifica_cliente, 
             PARK_Contratos_Tipo.Tipo_pagamento, 
             PARK_Contratos_Tipo.servico_rotativo, 
             PARK_Contratos_Tipo.Cod_Tipo_preco,
		    PARK_Contratos_Tipo.Qtd_minutos_Tolerancia
INTO  :str_dados_Contratos.CONTr_valid_contrato,
         :str_dados_Contratos.CONTr_Perct_de_desc, 
         :str_dados_Contratos.CONTr_TP_cod_tp_contrato ,
         :str_dados_Contratos.CONTr_TP_desc_tp_contrato,
         :str_dados_Contratos.CONTr_TP_Att_por_oper ,
         :str_dados_Contratos.CONTr_TP_Identifica_cliente,
         :str_dados_Contratos.CONTr_TP_Tp_pgmto,
         :str_dados_Contratos.CONTr_TP_servico_rotativo,
         :str_dados_Contratos.CONTr_TP_Cod_Tp_preco,
		:str_dados_Contratos.CONTr_Qtd_minutos_Tolerancia
FROM PARK_Contratos INNER JOIN PARK_Contratos_Tipo ON 
          PARK_Contratos.Tipo_contrato = PARK_Contratos_Tipo.cod_tipo_contrato
WHERE PARK_Contratos.chave_contratos = :str_dados_Contratos.CONTr_Num_contrato
USING SQLCA;
//
   wsf_msg_erro_db[1]  =  "Falha BD - FS_Rotina_Apuracao -CR02"
   wsf_msg_erro_db[2]  = SQLCA.SQLERRTEXT  
   wsf_cod_erro_db       =  SQLCA.SQLCODE
 //
IF  wsf_cod_erro_db <> 0 then 
	Return false
End if
//
*/
/* CR 03 *//* Recupera o tipo de movimento entrada ou saida */

//select tipo_operacao
//INTO :str_dados_Placa.ULT_Oper_entr_sai
//from PARK_Movimento_Diario
//where (chave_contratos               =  :STR_Dados_Contrato.contr_chave_contratos       and
//           chave_movimento_diario   =  :STR_Dados_Cartao.chave_movimento_diario       and
//           CHave_cartao                  =  :STR_Dados_Cartao.Chave_Cartao                       and
//		  placa_veiculo                   =  :STR_Dados_Placa.cod_placa )
//USING SQLCA;
////
//   wsf_msg_erro_db[1]  =  "Falha BD - FS_Rotina_Apuracao -CR03"
//   wsf_msg_erro_db[2]  = SQLCA.SQLERRTEXT  
//   wsf_cod_erro_db       =  SQLCA.SQLCODE
// //
//IF  wsf_cod_erro_db <> 0 then 
//	Return false
//End if

/* CR 04 */
IF STR_Dados_Contrato.contr_tp_servico_rotativo  Then
    IF fs_rotina_apuracao_Rotativo( wsf_msg_erro_db, wsf_cod_erro_db) Then
    
    End IF
  ElseIF NOT STR_Dados_Contrato.contr_tp_servico_rotativo Then
       IF fs_rotina_apuracao_Contratado() Then
    
       End IF
End IF


Return True
	                                                                                 
end function

public function boolean fs_qtd_minutos (ref datetime wsf_dta_entrada, ref datetime wsf_dta_saida, ref string wsf_msg_erro_db[], ref integer wsf_cod_erro_db, ref long wsf_qtd_minutos);/*    
fs_qtd_minutos
wsf_dta_entrada
wsf_dta_saida
wsf_msg_erro_db[]
wsf_cod_erro_db
wsf_qtd_minutos

*/
int ws_qtd_dias
long ws_qtd_segundos
long ws_qtde_seg_dia_anterior,  ws_qtde_seg_dia_posterior
constant long ws_segundos_dias = 86400
////////
ws_qtd_dias = DaysAfter(date(WSF_dta_entrada), date(WSF_dta_saida) )
	 ws_qtde_seg_dia_anterior   =  SecondsAfter( time(WSF_dta_entrada), time("23:59:59") )
	 ws_qtde_seg_dia_posterior =  SecondsAfter( time("00:00:01"), time(WSF_dta_saida)  )


CHOOSE CASE ws_qtd_dias

CASE  0             /* entrada e saida no mesmo dia */
	        ws_qtd_segundos = SecondsAfter( time(WSF_dta_entrada),  time(WSF_dta_saida)  )

CASE   1            /*    saida no dia seginte */
	
	        ws_qtd_segundos  =  ( ws_qtde_seg_dia_anterior + ws_qtde_seg_dia_posterior )  

CASE is > 1      /* saida com mais de 24 horas */
             ws_qtd_segundos  =  ( ws_qtde_seg_dia_anterior + ws_qtde_seg_dia_posterior )  
             ws_qtd_segundos  =  ws_qtd_segundos  + ( ( ws_qtd_dias - 1) * ws_segundos_dias)

END CHOOSE

 If ws_qtd_segundos >= 60 then
	WSF_Qtd_minutos = ( ws_qtd_segundos / 60)
  Else
	WSF_Qtd_minutos = 1
End IF 
//messagebox("segundos", " entrada-> " +    string (WSF_dta_entrada, "dd/mm/yyyy hh:mm:ss")   + " ~n "  + & 
//                                     "     saida-> " +    string (WSF_dta_saida,     "dd/mm/yyyy hh:mm:ss")  + " ~n "  + &
//								 "qtd_ant -> "  +    string (ws_qtde_seg_dia_anterior)                            + " ~n "  + &
//								 "qtd_pos -> "  +    string (ws_qtde_seg_dia_posterior)                          + " ~n "  + & 
//								 "qtd_Min -> "  +    string (WSF_Qtd_minutos)                                       + " ~n "  + & 
//								 "Dias      -> "  +     string( ws_qtd_dias ))
											

return true
end function

public function long fs_recebimento_cheques ();/*   */

setnull(str_dados_cartoes_pelo_user.chave_cadastro_cheque)
////////////////////////////
Open( PARK_Cadastro_Cheques )

IF ISnull( str_dados_cartoes_pelo_user.chave_cadastro_cheque ) Then
	str_dados_cartoes_pelo_user.chave_cadastro_cheque  = 000
End IF

Return  str_dados_cartoes_pelo_user.chave_cadastro_cheque
end function

public function boolean fs_apuracao_rotativo_rot01_tolera (ref string wsf_msg_erro_db[], ref integer wsf_cod_erro_db);/*  apurar e fazer o lancamento na conta cliente  em movimento de entrata   Lançar o periodo inicial e o desconto se houver   
     procedimentos diferentes para preço fixo e variavel  verificação do tipo de preço 1 pgmt hora e 2 preço fixo  
     sendo preço fixo lançar na conta cliente o valor apurado  sendo preço hora, lançar o valor da parte inicial  */
	
 /* CR 01 */ /* verificação do tipo de preço */
  	  string       Ws_codigo_lancamento
	  string       WS_Conta_Cliente_Obs[]
	  dec {2}     ws_valor_lancamento
	  long         ws_carimbo_lanc_caixa
	  datetime   WS_data_pagmto
	  datetime   Ws_data_Vigencia
	  Long        WS_chave_preco_variavel
////////////////////////////////////////////////////////////////////////////////	  
	  
	  ws_conta_cliente_obs[1] = "Lançamento automático feito pelo Sistema"
	  ws_conta_cliente_obs[2] = "Conforme Contrato"
       ws_carimbo_lanc_caixa  = 000
//	  
 IF  str_dados_Contrato.contr_tp_cod_tipo_preco  =  "1" then   /* Preço por hora */
      /* lanca periodo inicial *//* se houver, lança desconto sobre o periodo inicial */
	  string       WS_query_lancamento
       string       Ws_Cod_lanc_cta_cliente_periodo_inicial	, Ws_Cod_lanc_cta_cliente_periodo_inicial_II
	  string       Ws_Cod_lanc_cta_cliente_Fracao
	  string       Ws_Cod_lanc_cta_cliente_periodo_inicial_DescTo
	  string       Ws_Cod_lanc_cta_cliente_Fracao_DescTo
	  string       Ws_cta_cliente_periodo_inicial_estorno 
	  string       Ws_cta_cliente_periodo_inicial_DescTo_estorno

       Int           Ws_QTD_Minutos_periodo_Inicial,  Ws_QTD_Minutos_periodo_Inicial_ii
	   Int	        Ws_QTD_minutos_fracao
	  Int           ws_sequencia_lancamento
       Dec {2}   Ws_Valor_preco_periodo_inicial,  Ws_Valor_preco_periodo_inicial_ii
	  Dec {2}   Ws_Valor_preco_Fracao
         
	   Long        ws_cod_lanc_mo_dia		
	   Datetime ws_dta_lancamento
 
	   //
	 ws_dta_lancamento = Datetime(today(), now())
      ws_cod_lanc_mo_dia  = 0000	
     /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//       WS_data_pagmto  =  datetime(today(), time( "00:00:01" ))
         WS_data_pagmto  = STR_Dados_Placa.data_entrada
         Setnull( Ws_data_Vigencia )
        SELECT  MAX(data_inicio_vigencia_preco_variavel)	 
             INTO  :Ws_data_Vigencia
	      FROM 	PARK_Preco_Variavel_Hora 	
         WHERE 	PARK_Preco_Variavel_Hora.Codigo_Tipo_vaga                             =    :STR_Dados_Placa.cod_tipo_vaga	                             AND
			         PARK_Preco_Variavel_Hora.cod_tipo_contrato                             =    :STR_dados_Contrato.contr_tp_cod_tipo_contrato       AND
				    PARK_Preco_Variavel_Hora.data_inicio_vigencia_preco_variavel    <=   :WS_data_pagmto
             Using SQLCA;
 
         SELECT  PARK_Preco_Variavel_Hora.Chave_preco_variavel_hora
              INTO    :WS_chave_preco_variavel
	        FROM 	PARK_Preco_Variavel_Hora 	
          WHERE 	PARK_Preco_Variavel_Hora.Codigo_Tipo_vaga                             =    :STR_Dados_Placa.cod_tipo_vaga	                             AND
			              PARK_Preco_Variavel_Hora.cod_tipo_contrato                             =    :STR_dados_Contrato.contr_tp_cod_tipo_contrato       AND
				         PARK_Preco_Variavel_Hora.data_inicio_vigencia_preco_variavel     =   :Ws_data_Vigencia
                 Using SQLCA;
            //////////////////////////////////////////////////////////////////////////////////////////////////////////////		
           SELECT   PARK_Preco_Variavel_Hora.QTD_Minutos_periodo_Inicial, 
			             PARK_Preco_Variavel_Hora.QTD_Minutos_periodo_Inicial_ii, 
	                      PARK_Preco_Variavel_Hora.QTD_minutos_fracao, 
	                      PARK_Preco_Variavel_Hora.Valor_preco_periodo_inicial, 
					 PARK_Preco_Variavel_Hora.Valor_preco_periodo_inicial_ii, 			 
	                      PARK_Preco_Variavel_Hora.Valor_preco_Fracao,
				         PARK_Preco_Variavel_Hora.Cod_lanc_cta_cliente_periodo_inicial	,
					   PARK_Preco_Variavel_Hora.Cod_lanc_cta_cliente_periodo_inicial_ii,
				         PARK_Preco_Variavel_Hora.Cod_lanc_cta_cliente_Fracao,
				         PARK_Preco_Variavel_Hora.Cod_lanc_cta_cliente_periodo_inicial_DescTo,
				         PARK_Preco_Variavel_Hora.Cod_lanc_cta_cliente_Fracao_DescTo,
    			              PARK_Preco_Variavel_Hora.Cod_lanc_cta_cliente_periodo_inicial_estorno,
                           PARK_Preco_Variavel_Hora.Cod_lanc_cta_cliente_periodo_inicial_DescTo_estorno
                INTO   :Ws_QTD_Minutos_periodo_Inicial,
					  :Ws_QTD_Minutos_periodo_Inicial_ii,
	 	                  :Ws_QTD_minutos_fracao,
                           :Ws_Valor_preco_periodo_inicial,
					 :Ws_Valor_preco_periodo_inicial_ii,
	                      :Ws_Valor_preco_Fracao,
				        :Ws_Cod_lanc_cta_cliente_periodo_inicial,	
					   :Ws_Cod_lanc_cta_cliente_periodo_inicial_ii,
				        :Ws_Cod_lanc_cta_cliente_Fracao,
				        :Ws_Cod_lanc_cta_cliente_periodo_inicial_DescTo,
                             :Ws_Cod_lanc_cta_cliente_Fracao_DescTo,
 				        :Ws_cta_cliente_periodo_inicial_estorno,
 				        :Ws_cta_cliente_periodo_inicial_DescTo_estorno
	         FROM 	PARK_Preco_Variavel_Hora 				
	      WHERE 	PARK_Preco_Variavel_Hora.Chave_preco_variavel_hora   =  :WS_chave_preco_variavel
              Using SQLCA;
                wsf_msg_erro_db[1]  =  "Falha BD-fs_apuracao_rotativo_rot01 - CR01"
                wsf_msg_erro_db[2]  =   SQLCA.SQLERRTEXT  
                wsf_cod_erro_db       =   SQLCA.SQLCODE
              //
      IF  wsf_cod_erro_db <> 0 then 
		  messagebox("Falha BD-fs_apuracao_rotativo_rot01 - CR01","Não foi lançado o valor na conta cliente "  + " ~n "  + &
		                                     wsf_msg_erro_db[1] + " " +  wsf_msg_erro_db[2]    )
	      Return false
      End if
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////		
//        SELECT  PARK_Preco_Variavel_Hora.QTD_Minutos_periodo_Inicial, 
//	                  PARK_Preco_Variavel_Hora.QTD_minutos_fracao, 
//	                  PARK_Preco_Variavel_Hora.Valor_preco_periodo_inicial, 
//	                  PARK_Preco_Variavel_Hora.Valor_preco_Fracao,
//				    PARK_Preco_Variavel_Hora.Cod_lanc_cta_cliente_periodo_inicial,
//				    PARK_Preco_Variavel_Hora.Cod_lanc_cta_cliente_Fracao,
//				    PARK_Preco_Variavel_Hora.Cod_lanc_cta_cliente_periodo_inicial_DescTo,
//				    PARK_Preco_Variavel_Hora.Cod_lanc_cta_cliente_Fracao_DescTo,
//				    PARK_Preco_Variavel_Hora.Cod_lanc_cta_cliente_periodo_inicial_estorno,
//                      PARK_Preco_Variavel_Hora.Cod_lanc_cta_cliente_periodo_inicial_DescTo_estorno
//        INTO   :Ws_QTD_Minutos_periodo_Inicial,
//	 	         :Ws_QTD_minutos_fracao,
//                  :Ws_Valor_preco_periodo_inicial,
//	              :Ws_Valor_preco_Fracao,
//				:Ws_Cod_lanc_cta_cliente_periodo_inicial,	
//				:Ws_Cod_lanc_cta_cliente_Fracao,
//				:Ws_Cod_lanc_cta_cliente_periodo_inicial_DescTo,
//                  :Ws_Cod_lanc_cta_cliente_Fracao_DescTo,
//				:Ws_cta_cliente_periodo_inicial_estorno,
//				:Ws_cta_cliente_periodo_inicial_DescTo_estorno
//       FROM  PARK_Preco_Variavel_Hora   
//      WHERE  PARK_Preco_Variavel_Hora.Codigo_Tipo_vaga   =  :STR_Dados_placa.cod_tipo_vaga     and
//		           PARK_Preco_Variavel_Hora.cod_tipo_contrato   =  :STR_dados_Contrato.contr_tp_cod_tipo_contrato
//      Using SQLCA;
//
//       wsf_msg_erro_db[1]  =  "Falha BD-fs_apuracao_rotativo_rot01 - CR01"
//      wsf_msg_erro_db[2]  =   SQLCA.SQLERRTEXT  
//      wsf_cod_erro_db       =   SQLCA.SQLCODE
//      //
//      IF  wsf_cod_erro_db <> 0 then 
//		 messagebox("Falha BD-fs_apuracao_rotativo_rot01 - CR01","Não foi lançado o valor na conta cliente "  + " ~n "  + &
//		                                     wsf_msg_erro_db[1] + " " +  wsf_msg_erro_db[2]    )
//	      Return false
//      End if
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	 /* Calculo do valor periodo inicial */
              /* Lançamento Periodo Inicial */
				  ws_conta_cliente_obs[2]     =   ws_conta_cliente_obs[2]               +  " Lançamento Periodo Inicial"
				  ws_valor_lancamento          =   Ws_Valor_preco_periodo_inicial
				  Ws_codigo_lancamento      =   Ws_Cod_lanc_cta_cliente_periodo_inicial
				  
                 IF Not   FS_ROT_Apur_Efetiva_lancamto(STR_dados_Contrato.contr_chave_contratos,          &
					                                                      STR_dados_Cartao.chave_cartao,                           &
                                                                             STR_Dados_Placa.Cod_Placa,                               &
																	 Ws_codigo_lancamento,                                        &
					                                                       ws_valor_lancamento,                                            &
																	 ws_carimbo_lanc_caixa ,                                       &
																	 ws_cod_lanc_mo_dia,                                            &
																	 wsf_msg_erro_db,                                                  &
																	 wsf_cod_erro_db,                                                   &
																	 ws_conta_cliente_obs,                                            &
																	 STR_dados_Contrato.contr_tp_cod_tipo_contrato)              Then
					Return False
			  End IF	
			  
			  
             /* Lançamento desconto conforme contrato, se houver */
				  ws_valor_lancamento          =   Ws_Valor_preco_periodo_inicial
				  Ws_codigo_lancamento       =  Ws_cta_cliente_periodo_inicial_estorno
				  //
				   ws_conta_cliente_obs[3] = "Desconto " + trim(string(str_dados_Contrato.contr_percentual_de_desconto)) +"% S/Periodo Inicial"
					
                     IF Not   FS_ROT_Apur_Efetiva_lancamto(STR_Dados_Contrato.contr_chave_contratos,               &
					                                                          STR_Dados_Cartao.Chave_Cartao,                               &
                                                                                 STR_Dados_Placa.Cod_Placa,                                    &
																	    Ws_codigo_lancamento,                                              &
					                                                          ws_valor_lancamento,                                                  &
																		ws_carimbo_lanc_caixa ,                                             &
																		ws_cod_lanc_mo_dia,                                                  &
																	    wsf_msg_erro_db,                                                        &
																	    wsf_cod_erro_db,                                                         &
																	    ws_conta_cliente_obs,                                                 &
																		STR_dados_Contrato.contr_tp_cod_tipo_contrato)              Then
					   Return False
			        End IF			
			 
 
ElseIF   str_dados_Contrato.contr_tp_cod_tipo_preco  =  "2" then   /*Preço Fixo */
	       /* lanca Valor total *//* se houver, lança  o desconto  */
			  string WS_Cod_lanc_CTA_Cliente
			  string WS_Cod_lanc_CTA_Cliente_DescTo
			  dec {2} WS_Preco_fixo, Ws_desc_fixo
	        SELECT PARK_Preco_Fixo.Preco_fixo,
			           PARK_Preco_Fixo.Cod_lanc_CTA_Cliente, 
					  PARK_Preco_Fixo.Cod_lanc_CTA_Cliente_DescTo
			 Into   :WS_Preco_fixo,
			          :WS_Cod_lanc_CTA_Cliente,
			          :WS_Cod_lanc_CTA_Cliente_DescTo
             FROM PARK_Cadastro_Placas INNER JOIN PARK_Preco_Fixo ON 
				    PARK_Cadastro_Placas.Cod_tipo_vaga   =    PARK_Preco_Fixo.Codigo_Tipo_vaga
              WHERE  PARK_Preco_Fixo.cod_tipo_contrato  =    :str_dados_Contrato.contr_tp_cod_tipo_contrato  AND 
				        PARK_Cadastro_Placas.COD_placa     =   :STR_Dados_Placa.Cod_placa
                 Using SQLCA;
             wsf_msg_erro_db[1]  =  "Falha BD-fs_apuracao_rotativo_rot01 - CR02"
             wsf_msg_erro_db[2]  =   SQLCA.SQLERRTEXT  
             wsf_cod_erro_db       =   SQLCA.SQLCODE
             //
         IF  wsf_cod_erro_db <> 0 then 
		    messagebox("falha BD","Não foi lançado o valor na conta cliente " + " ~n "+ &
			                                    wsf_msg_erro_db[1] + "   " + wsf_msg_erro_db[2] )
	         Return false
         End if
	      //	
			 ws_conta_cliente_obs[2] = ws_conta_cliente_obs[2] + " Preço Fixo " 
			 Ws_codigo_lancamento  = WS_Cod_lanc_CTA_Cliente
			 ws_valor_lancamento    = WS_Preco_fixo  
			
			  IF Not   FS_ROT_Apur_Efetiva_lancamto(     STR_Dados_Contrato.contr_chave_contratos,               &
					                                                          STR_Dados_Cartao.Chave_cartao,                               &
                                                                                 STR_Dados_Placa.Cod_placa,                                    &
																	    Ws_codigo_lancamento,                                             &
					                                                          ws_valor_lancamento,                                                 &
																		ws_carimbo_lanc_caixa ,                                            &
																		ws_cod_lanc_mo_dia,                                                 &
																	    wsf_msg_erro_db,                                                       &
																	    wsf_cod_erro_db,                                                        &
																	    ws_conta_cliente_obs,                                                 &
																		STR_dados_Contrato.contr_tp_cod_tipo_contrato)        Then
					Return False
			  End IF			
             /* Lançamento desconto conforme contrato, se houver */

				     Ws_codigo_lancamento       = WS_Cod_lanc_CTA_Cliente_DescTo
				  //
				      ws_conta_cliente_obs[3] = trim(string(str_dados_Contrato.contr_percentual_de_desconto))+"% Preço Fixo "
					  ws_valor_lancamento =  WS_Preco_fixo  
						
					  IF Not   FS_ROT_Apur_Efetiva_lancamto(STR_Dados_Contrato.contr_chave_contratos,            &
					                                                              STR_Dados_Cartao.Chave_cartao,                            &
                                                                                    STR_Dados_Placa.Cod_Placa,                                  &
																	        Ws_codigo_lancamento,                                           &
					                                                              ws_valor_lancamento,                                              &
																		    ws_carimbo_lanc_caixa ,                                         &
																		    ws_cod_lanc_mo_dia,                                             &
																	         wsf_msg_erro_db,                                                   &
																	         wsf_cod_erro_db,                                                    &
																	         ws_conta_cliente_obs,                                            &
																			STR_dados_Contrato.contr_tp_cod_tipo_contrato )    Then
					            Return False
			             End IF			
End IF
///////////////////////////////////////////////////////
///CR01 /// Recupera o indice maior na placa
string      ws_justificativas_operador[]
datetime WS_Data_obs
long        ws_Indice_LInhas
long        ws_index_justificativas
Setnull( ws_Indice_LInhas )
SELECT  max(PARK_Cadastro_Placas_OBS.Indice_LInhas)
     INTO  :ws_Indice_LInhas
  FROM   PARK_Cadastro_Placas_OBS 
WHERE  PARK_Cadastro_Placas_OBS.COD_placa   =  :STR_Dados_Placa.Cod_placa
    Using  SQLCA;
IF isnull( ws_Indice_LInhas) then
	ws_Indice_LInhas = 0
End IF
///////////////////////////////////////////////////////////////
WS_Data_obs = datetime(today(), now())
ws_justificativas_operador[1] = "Qtd Minutos:  "    +  trim(string (STR_Dados_Placa.QTD_Minutos)) +  " Saída por Tolerância <> Operador: " + Trim(str_dados_Operador.stru_codigo_usuario_operador )
 ws_index_justificativas = upperbound(ws_justificativas_operador)
int ws_a
For WS_A = 1 to ws_index_justificativas
	ws_Indice_LInhas++
	INSERT INTO PARK_Cadastro_Placas_OBS 
	                 ( 
					   COD_placa,
                          Indice_LInhas,
                          OBS_PLACA,
                          Data_Incusao_obs 
					)
            Values
			            (
	                         :STR_Dados_Placa.Cod_placa,
				            :ws_Indice_LInhas,		 
	                         :ws_justificativas_operador[ ws_a ],
	                         :WS_Data_obs 
	                     )
	         Using  SQLCA;
Next
///////////////////////////////////////////////////////////////////////////////////
UPDATE  PARK_Cadastro_Placas 
       SET  PARK_Cadastro_Placas.Flag_OBS  =  'S'
WHERE   PARK_Cadastro_Placas.COD_placa  =  :STR_Dados_Placa.Cod_placa
   USING  SQLCA;
///////////////////////////////////////////////////////////////////////////////////










Return true
end function

public function boolean fs_cliente_lanca_caixa (ref string wsf_chave_cartao, ref long wsf_chave_contrato, ref string wsf_chave_placa, ref decimal wsf_valor, ref long wsf_chave_tabela_movimento_diario, ref string wsf_msg_erro_db[], ref integer wsf_cod_erro_db, ref string wsf_cod_deb_cred, ref long wsf_chave_cadastro_cheques);/*
fs_cliente_lanca_caixa
wsf_chave_cartao
wsf_chave_Contrato
wsf_chave_placa
wsf_valor
wsf_chave_tabela_movimento_diario
wsf_msg_erro_db[]
wsf_cod_erro_db
wsf_cod_deb_cred

 executar um lançamento na conta caixa 
    1- recuperar a capa de lote
	2-executar o lançamento 
	3-carimbar os registros incluidos no lancamento da conta cliente 
 */
// ws_cod_usuario   //operador  // str_dados_Operador.stru_chave_operador
//////////
long        ws_capa_de_lote
int     ws_cod_lancamentos
datetime ws_data_hora_Lancamento
long        ws_Caixa_lancamento_OBS
long         ws_chave_lancamentos_caixa
//////
 ws_data_hora_Lancamento   =  datetime(today(), Now())
ws_Caixa_lancamento_OBS = 000 
 
 /* 1- recuperar a capa de lote */
setnull( ws_capa_de_lote )
SELECT max(PARK_Caixa_fechamentos.chave_fechamento_caixa)
Into      :ws_capa_de_lote
FROM   PARK_Caixa_fechamentos 
Where  PARK_Caixa_fechamentos.Chave_usuario = :str_dados_Operador.stru_chave_operador and 
            PARK_Caixa_fechamentos.Flag_fechado    = 'N' 
  Using SQLCA;

IF isnull ( ws_capa_de_lote ) Then 
       SELECT  max(PARK_Caixa_fechamentos.chave_fechamento_caixa)
              Into    :ws_capa_de_lote
          FROM   PARK_Caixa_fechamentos 
          Where   PARK_Caixa_fechamentos.Flag_fechado    = 'N' 
           Using   SQLCA;
	          wsf_msg_erro_db[1]  =  "fs_apur_rotat_lanc_ct_clie - CR01 Insert"
               wsf_msg_erro_db[2]  =   SQLCA.SQLERRTEXT  
               wsf_cod_erro_db       =   SQLCA.SQLCODE
           //
              IF  wsf_cod_erro_db <> 0   then  
		               messagebox("Falha DB ", "não foi efetivado o lancamanto   ~n  " + &
		                                  "fs_cliente_lanca_caixa       ~n  " +      SQLCA.SQLERRTEXT  )
	                   Return false
               End if	
 End IF		 
//
 /* fim 1- recuperar a capa de lote */
 /* 2-executar o lançamento */
 
       
IF   wsf_cod_deb_cred = "C" then
	 ws_cod_lancamentos  = 1
elseIF   wsf_cod_deb_cred = "D"  then
	 ws_cod_lancamentos  = 2
elseIF   wsf_cod_deb_cred <> "C"  and  wsf_cod_deb_cred <> "D" 	 then
	    Messagebox("Erro","Lançamento no caixa sem codigo deb cred ~n" + &
		                            "Não foi executado")
End If
//
insert into  PARK_Caixa_Lancamentos
           ( chave_caixa_fechamentos,
             Chave_usuario, 
             Chave_contratos, 
             data_hora_Lancamento, 
             cod_lancamentos, 
             Valor_lancamento, 
             cod_debito_credito, 
             Caixa_lancamento_OBS,
			chave_cadastro_cheques)
   Values
	       (:ws_capa_de_lote,
             :str_dados_Operador.stru_chave_operador,
			:wsf_chave_Contrato,
			:ws_data_hora_Lancamento,
			:ws_cod_lancamentos,	 
			:wsf_valor,
			:wsf_cod_deb_cred,
			:ws_Caixa_lancamento_OBS,
			:Wsf_chave_cadastro_cheques)	 
  Using SQLCA;
	  wsf_msg_erro_db[1]  =  "Inclusão de Registro no caixa"
       wsf_msg_erro_db[2]  =   SQLCA.SQLERRTEXT  
       wsf_cod_erro_db       =   SQLCA.SQLCODE
       //
       IF  wsf_cod_erro_db <> 0   then  
		  messagebox("Falha DB ", "fs_cliente_lanca_caixa - "  +  "~n  "   + & 
		                                         "não foi efetivado o lancamanto no caixa~n  " + &
		                                           SQLCA.SQLERRTEXT   )
	       Return false
       End if				
///
 /* Fim 2-executar o lançamento */		
/*	3-carimbar os registros incluidos no lancamento da conta cliente 	*/		
		/*  Recupera o ultimo registro do caixa  */	
			
SELECT max(PARK_Caixa_Lancamentos.chave_caixa_lancamentos)
into :ws_chave_lancamentos_caixa
FROM PARK_Caixa_Lancamentos 
where PARK_Caixa_Lancamentos.Chave_usuario   = :str_dados_Operador.stru_chave_operador   and
          PARK_Caixa_Lancamentos.Chave_contratos = :wsf_chave_Contrato
   Using SQLCA;
	  wsf_msg_erro_db[1]  =  "Inclusão de Registro no caixa"
       wsf_msg_erro_db[2]  =   SQLCA.SQLERRTEXT  
       wsf_cod_erro_db       =   SQLCA.SQLCODE
       //
       IF  wsf_cod_erro_db <> 0   then  
		  messagebox("Falha DB ", "não foram  carimbados os registros da conta cliente ~n  " + &
		                                        SQLCA.SQLERRTEXT   )
	       Return false
       End if				
 
UPdate PARK_Conta_cliente
set  chave_caixa_lancamentos = :ws_chave_lancamentos_caixa
where  (chave_movimento_diario = :wsf_chave_tabela_movimento_diario ) and
          ( chave_movimento_diario  <> 0 )   and
		 ( chave_contratos     =   :wsf_chave_contrato)  and
		 ( CHave_cartao         =   :wsf_chave_cartao)  and
		 ( COD_placa            =   :wsf_chave_placa)
   Using SQLCA;
	  wsf_msg_erro_db[1]  =  "Carimbo da conta cliente"
       wsf_msg_erro_db[2]  =   SQLCA.SQLERRTEXT  
       wsf_cod_erro_db       =   SQLCA.SQLCODE
       //
       IF  wsf_cod_erro_db <> 0   then  
		  messagebox("Falha DB ", "não foram  carimbados os registros de movimento ~n  " + &
		                                        SQLCA.SQLERRTEXT   )
	       Return false
       End if	
//		 
IF isnull( ws_capa_de_lote) then
 	this.Trigger Event OU_Alerta_Lanca_caixa_fechado(ws_chave_lancamentos_caixa)
End IF
//
  Return true
end function

public function boolean fs_receb_mensalista_lanc_caixa (ref long wsf_chave_contrato, ref string wsf_msg_erro_db[], ref integer wsf_cod_erro_db, ref string wsf_cod_deb_cred, ref decimal wsf_valor, ref long wsf_chave_cadastro_cheques, ref long wsf_chave_fechamento_contrato, ref long wsf_chave_lancamentos_caixa);/*
fs_receb_mensalista_lanc_caixa
wsf_chave_Contrato
wsf_msg_erro_db[]
wsf_cod_erro_db
wsf_cod_deb_cred
wsf_valor
Wsf_chave_cadastro_cheques
WSf_Chave_Fechamento_contrato

 executar um lançamento na conta caixa 
    1- recuperar a capa de lote
	2-executar o lançamento 
	3-carimbar os registros incluidos no lancamento da conta cliente 
 */
// ws_cod_usuario   //operador  // str_dados_Operador.stru_chave_operador
//////////
long         ws_capa_de_lote
int            ws_cod_lancamentos
datetime   ws_data_hora_Lancamento
long          ws_Caixa_lancamento_OBS
//long          ws_chave_lancamentos_caixa
datetime   ws_data_conta_cli_inicio
datetime   ws_data_conta_cli_FIM
//////
 ws_data_hora_Lancamento   =  datetime(today(), Now())
ws_Caixa_lancamento_OBS = 000 
// chave_caixa_lancamentos
 /* 1- recuperar a capa de lote */
setnull( ws_capa_de_lote )
SELECT  max(PARK_Caixa_fechamentos.chave_fechamento_caixa)
     INTO   :ws_capa_de_lote
  FROM    PARK_Caixa_fechamentos 
   Where   PARK_Caixa_fechamentos.Chave_usuario = :str_dados_Operador.stru_chave_operador and 
               PARK_Caixa_fechamentos.Flag_fechado    = 'N' 
  Using SQLCA;

IF isnull ( ws_capa_de_lote ) Then 
       SELECT  max(PARK_Caixa_fechamentos.chave_fechamento_caixa)
              Into    :ws_capa_de_lote
          FROM   PARK_Caixa_fechamentos 
          Where   PARK_Caixa_fechamentos.Flag_fechado    = 'N' 
           Using   SQLCA;
	          wsf_msg_erro_db[1]  =  "fs_apur_rotat_lanc_ct_clie - CR01  select"
               wsf_msg_erro_db[2]  =   SQLCA.SQLERRTEXT  
               wsf_cod_erro_db       =   SQLCA.SQLCODE
           //
              IF  wsf_cod_erro_db <> 0   then  
		               messagebox("Falha DB - PARK_Caixa_fechamentos ", "não foi efetivado o lancamanto   ~n  " + &
		                                  "fs_cliente_lanca_caixa       ~n  " +      SQLCA.SQLERRTEXT  )
	                   Return false
               End if	
 End IF		 
//
 /* fim 1- recuperar a capa de lote */
 /* 2-executar o lançamento */
//       
IF   wsf_cod_deb_cred = "C" then
	  ws_cod_lancamentos  = 16
   elseIF   wsf_cod_deb_cred  =  "D"  then
	          ws_cod_lancamentos  = 17
   elseIF   wsf_cod_deb_cred  =  "X"  then
	          ws_cod_lancamentos  = 18
			 wsf_cod_deb_cred      = "C" 	 
    elseIF   wsf_cod_deb_cred <> "C"  and  wsf_cod_deb_cred <> "D" 	and  wsf_cod_deb_cred <> "X"  then
	             Messagebox("fs_receb_mensalista_lanc_caixa","Lançamento no caixa sem codigo deb cred ~n  Não foi executado")
End If
//
insert into  PARK_Caixa_Lancamentos
           ( chave_caixa_fechamentos,
             Chave_usuario, 
             Chave_contratos, 
             data_hora_Lancamento, 
             cod_lancamentos, 
             Valor_lancamento, 
             cod_debito_credito, 
             Caixa_lancamento_OBS,
			chave_cadastro_cheques)
   Values
	       (:ws_capa_de_lote,
             :str_dados_Operador.stru_chave_operador,
			:wsf_chave_Contrato,
			:ws_data_hora_Lancamento,
			:ws_cod_lancamentos,	 
			:wsf_valor,
			:wsf_cod_deb_cred,
			:ws_Caixa_lancamento_OBS,
			:Wsf_chave_cadastro_cheques)	 
  Using SQLCA;
	  wsf_msg_erro_db[1]  =  "Inclusão de Registro no caixa"
       wsf_msg_erro_db[2]  =   SQLCA.SQLERRTEXT  
       wsf_cod_erro_db       =   SQLCA.SQLCODE
       //
       IF  wsf_cod_erro_db <> 0   then  
		  messagebox("Falha DB ", "fs_cliente_lanca_caixa - "  +  "~n  "   + & 
		                                         "não foi efetivado o lancamanto no caixa~n  " + &
		                                           SQLCA.SQLERRTEXT   )
	       Return false
       End if				
///
 /* Fim 2-executar o lançamento */		
/*	3-carimbar os registros incluidos no lancamento da conta cliente 	*/		
		/*  Recupera o ultimo registro do caixa  */	

SELECT max(PARK_Caixa_Lancamentos.chave_caixa_lancamentos)
into :wsF_chave_lancamentos_caixa
FROM PARK_Caixa_Lancamentos 
where PARK_Caixa_Lancamentos.Chave_usuario   = :str_dados_Operador.stru_chave_operador   and
          PARK_Caixa_Lancamentos.Chave_contratos = :wsf_chave_Contrato
   Using SQLCA;
	  wsf_msg_erro_db[1]  =  "Inclusão de Registro no caixa"
       wsf_msg_erro_db[2]  =   SQLCA.SQLERRTEXT  
       wsf_cod_erro_db       =   SQLCA.SQLCODE
       //
       IF  wsf_cod_erro_db <> 0   then  
		  messagebox("Falha DB - PARK_Caixa_Lancamentos ", "não foram  carimbados os registros da conta cliente ~n  " + &
		                                        SQLCA.SQLERRTEXT   )
	       Return false
       End if				
///////////////  CR01 /////////////////////////
SELECT  PARK_Fechamento_Contrato.Periodo_apurado_inicio, 
               PARK_Fechamento_Contrato.Periodo_apurado_fim 
     INTO  :ws_data_conta_cli_inicio,
	          :ws_data_conta_cli_FIM
    From 	PARK_Fechamento_Contrato			 
WHERE  PARK_Fechamento_Contrato.chave_fechamento  =  :WSf_Chave_Fechamento_contrato
  Using SQLCA; 
         IF  wsf_cod_erro_db <> 0   then  
		     messagebox("fs_receb_mensalista_lanc_caixa ", "CR01 - Não foram  carimbados os registros da conta cliente ~n  " + &
		                                        SQLCA.SQLERRTEXT   )
			Return false
         End if				
///////////// CR2 //////////////////////////
IF WSf_Chave_Fechamento_contrato <> 0 then 
      UPdate PARK_Conta_cliente
            set     chave_caixa_lancamentos     =     :wsF_chave_lancamentos_caixa
         where   chave_caixa_lancamentos      =      000             And
                      chave_fechamento                =    :WSf_Chave_Fechamento_contrato
          Using SQLCA; 
	         wsf_msg_erro_db[1]  =  "Carimbo da conta cliente"
              wsf_msg_erro_db[2]  =   SQLCA.SQLERRTEXT  
              wsf_cod_erro_db       =   SQLCA.SQLCODE
       //
             IF  wsf_cod_erro_db <> 0   then  
                    messagebox("fs_receb_mensalista_lanc_caixa ", "CR2-Não foram  carimbados os registros da conta cliente ~n  " + &
		                                        SQLCA.SQLERRTEXT   )
	              Return false
             End if				
End if
//
//  UPdate PARK_Conta_cliente
//    set     chave_caixa_lancamentos = :wsF_chave_lancamentos_caixa
//  where   chave_contratos                 =   :wsf_chave_Contrato                  And
//             (  Dta_lancamento                  >=   :ws_data_conta_cli_inicio     And
//		       Dta_lancamento                 <=    :ws_data_conta_cli_FIM   )    and
//			   chave_caixa_lancamentos	= 00   
//   Using SQLCA; 
//	  wsf_msg_erro_db[1]  =  "Carimbo da conta cliente"
//       wsf_msg_erro_db[2]  =   SQLCA.SQLERRTEXT  
//       wsf_cod_erro_db       =   SQLCA.SQLCODE
//       //
//       IF  wsf_cod_erro_db <> 0   then  
//		  messagebox("fs_receb_mensalista_lanc_caixa ", "CR2-Não foram  carimbados os registros da conta cliente ~n  " + &
//		                                        SQLCA.SQLERRTEXT   )
//	       Return false
//       End if				
//
///////////// CR3 //////////////////////////		 
UPDATE PARK_Fechamento_Contrato 
      SET PARK_Fechamento_Contrato.chave_caixa_lancamentos  =  :wsF_chave_lancamentos_caixa
WHERE  PARK_Fechamento_Contrato.chave_fechamento = :WSf_Chave_Fechamento_contrato 
   Using SQLCA; 
	  wsf_msg_erro_db[1]  =  "Carimbo do Fechamento"
       wsf_msg_erro_db[2]  =   SQLCA.SQLERRTEXT  
       wsf_cod_erro_db       =   SQLCA.SQLCODE
       //
       IF  wsf_cod_erro_db <> 0   then  
		  messagebox("fs_receb_mensalista_lanc_caixa ", "CR3-Não foram  carimbados os registros do Fechamento ~n  " + &
		                                        SQLCA.SQLERRTEXT   )
	       Return false
       End if		
		 
   Return true
end function

public function boolean fs_rot_apur_efetiva_lancamto (ref long wsf_chave_contrato, ref string wsf_chave_cartao, ref string wsf_cod_placa, ref string wsf_cod_lancamento, ref decimal wsf_valor_lancamento, ref long wsf_carimbo_lanc_caixa, ref long wsf_cod_lanca_mov_diario, ref string wsf_msg_erro_db[], ref integer wsf_cod_erro_db, ref string wsf_conta_cliente_obs[], ref string wsf_cod_tipo_contrato);/*  */
If wsf_valor_lancamento < 0.01 then
	Return true
End if
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
long          Ws_chave_movimento_diario,   ws_chave_fechamento
string        Ws_rotativo, ws_tipo_contrato_cliente
 Int             Ws_sequencia_lancamento		
datetime	  Ws_dta_lancamento
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
ws_dta_lancamento        = datetime(today(), now())
ws_chave_fechamento    = 000
////////////////////////////////////////////////////////////////////////
/*  verifica se é rotativo ou mensalista                         */
SELECT PARK_Contratos.Tipo_contrato
Into        :ws_tipo_contrato_cliente
FROM PARK_Contratos
WHERE  PARK_Contratos.chave_contratos  =  :wsf_chave_contrato 
 Using    SQLCA;
//////////////////////////////////////////////////////////////////////////////
SELECT PARK_Contratos_Tipo.servico_rotativo
     INTO  :ws_rotativo
FROM PARK_Contratos_Tipo
WHERE  PARK_Contratos_Tipo.cod_tipo_contrato =  :ws_tipo_contrato_cliente
 Using    SQLCA;
/////////////////////////////////////////////////////////////////////////////
/*  recupera o numero do registro referente a entrada e saida */
IF  WS_Rotativo = "S"  then               /*  É um contrato de Rotativo   */
    IF wsF_cod_lanca_mov_diario = 0 then 
             select    PARK_Cadastro_cartoes.chave_movimento_diario
                 into     :ws_chave_movimento_diario
                from    PARK_Cadastro_cartoes
              where   (PARK_Cadastro_cartoes.CHave_cartao         = :wsf_chave_cartao        and
                          PARK_Cadastro_cartoes.chave_contratos      = :wsf_chave_contrato     and 
                          PARK_Cadastro_cartoes.COD_placa             = :wsf_cod_placa            and
                          PARK_Cadastro_cartoes.status_cartao          =  1 )
                 Using SQLCA;
	                wsf_msg_erro_db[1]  =  "fs_rot_apur_efetiva_lancamto - CR01 "
                    wsf_msg_erro_db[2]  =   SQLCA.SQLERRTEXT  
                    wsf_cod_erro_db       =   SQLCA.SQLCODE
                  //
                        IF  wsf_cod_erro_db <> 0   then  
		                   messagebox("Falha DB - PARK_Cadastro_cartoes", "Não foi efetivado o lancamanto      ~n  " +    &
		                                                                                     wsf_msg_erro_db[1]             + "~n  " +    &
											                                             wsf_msg_erro_db[2]  	        + "~n  " +    &
																			        string(SQLCA.SQLCODE) )
	                         Return false
                         End if
           Else
            ws_chave_movimento_diario = wsF_cod_lanca_mov_diario	
     End IF	
	 	/// Pega a sequencia na tabela PARK_Conta_cliente ///
	        Select   max(seq_contrato_cartao_placa)
	           Into      :ws_sequencia_lancamento
	          from     PARK_Conta_cliente
	       Where    chave_movimento_diario    =  :ws_chave_movimento_diario
	        Using SQLCA;
	                  wsf_msg_erro_db[1]  =  "fs_rot_apur_efetiva_lancamto - CR02 Select"
                       wsf_msg_erro_db[2]  =   SQLCA.SQLERRTEXT  
                        wsf_cod_erro_db       =   SQLCA.SQLCODE
                    //
                    IF  wsf_cod_erro_db <> 0  and wsf_cod_erro_db  <> 100 then  
		                  messagebox("Falha DB -  PARK_Conta_cliente ", "Não foi efetivado o lancamanto      ~n  " +    &
		                                                                              wsf_msg_erro_db[1]                 + "~n  " +    &
											                                      wsf_msg_erro_db[2]  	  )
	                  Return false
                     End if
	               IF isnull( ws_sequencia_lancamento ) or  ws_sequencia_lancamento <  01 then
	                       ws_sequencia_lancamento   =   1
				 ELSEIF ws_sequencia_lancamento  >  00  then
				                   ws_sequencia_lancamento ++ 
				END IF
Else	   /* Não é rotativo */
				  
	 ws_chave_movimento_diario = 000
	 //
	 SELECT Min(PARK_Fechamento_Contrato.chave_fechamento)  AS  Chave_fechamento
	      INTO    :ws_chave_fechamento
        FROM PARK_Fechamento_Contrato
     WHERE  PARK_Fechamento_Contrato.chave_contratos    =   :wsf_chave_contrato    AND 
	               PARK_Fechamento_Contrato.data_recebimento_efetivado  Is Null 
	 Using SQLCA;
	 IF Isnull(ws_chave_fechamento)  Then
		ws_chave_fechamento = 000
	 End IF
	 IF  ws_chave_fechamento = 000  Then
	       SELECT Max(PARK_Fechamento_Contrato.chave_fechamento)  AS  Chave_fechamento
	            INTO    :ws_chave_fechamento
              FROM PARK_Fechamento_Contrato
           WHERE  PARK_Fechamento_Contrato.chave_contratos    =   :wsf_chave_contrato    
	       Using SQLCA;
      End IF
	 	 	/// Pega a sequencia na tabela PARK_Conta_cliente ///
	        Select   max(PARK_Conta_cliente.seq_contrato_cartao_placa)
	           Into      :ws_sequencia_lancamento
	          from     PARK_Conta_cliente
	       Where    PARK_Conta_cliente.chave_fechamento    =  :ws_chave_fechamento
	        Using SQLCA;
	                  wsf_msg_erro_db[1]  =  "fs_rot_apur_efetiva_lancamto - CR02 Select"
                       wsf_msg_erro_db[2]  =   SQLCA.SQLERRTEXT  
                        wsf_cod_erro_db       =   SQLCA.SQLCODE
                    //
                    IF  wsf_cod_erro_db <> 0  and wsf_cod_erro_db  <> 100 then  
		                  messagebox("Falha DB -  PARK_Conta_cliente ", "Não foi efetivado o lancamanto      ~n  " +    &
		                                                                              wsf_msg_erro_db[1]                 + "~n  " +    &
											                                      wsf_msg_erro_db[2]  	  )
	                  Return false
                     End if
	               IF isnull( ws_sequencia_lancamento ) or  ws_sequencia_lancamento <  01 then
	                       ws_sequencia_lancamento   =   1
				 ELSEIF ws_sequencia_lancamento  >  00  then
				                   ws_sequencia_lancamento ++ 
				END IF
	 
End IF	
///////////////////////////// inserir o registro n conta cliente ///////////////////////////////
				  Insert into PARK_Conta_cliente
			                      ( chave_contratos,                 
                                      CHave_cartao,                   
                                      COD_placa,                          
                                      seq_contrato_cartao_placa,   
								  cod_tipo_contrato,				  
                                      Chave_usuario,                    
                                      Cod_lancamento ,                 
                                      Dta_lancamento,
                                      Valor_lancamento ,    
								  chave_movimento_diario,
                                      chave_caixa_lancamentos,
								  chave_fechamento  )	  
				      Values (  :wsf_chave_contrato ,
				                    :wsf_chave_cartao,
				                    :wsf_cod_placa,
				                    :ws_sequencia_lancamento ,
								  :wsf_cod_tipo_contrato,
				                    :str_dados_Operador.stru_chave_operador,  
					                :wsF_Cod_lancamento,	
								  :ws_dta_lancamento,
				                    :wsF_Valor_lancamento ,
								  :ws_chave_movimento_diario,
				                    :wsf_carimbo_lanc_caixa,
								  :ws_chave_fechamento)
						Using SQLCA;
                               //
                              wsf_msg_erro_db[1]  =  "fs_rot_apur_efetiva_lancamto - CR03 Insert"
                              wsf_msg_erro_db[2]  =   SQLCA.SQLERRTEXT  
                              wsf_cod_erro_db       =   SQLCA.SQLCODE
                              //
                              IF  wsf_cod_erro_db <> 0 then  
		                           messagebox("Falha DB -  PARK_Conta_cliente ", "Não foi efetivado o lancamanto      ~n  " +    &
		                                                                                                  wsf_msg_erro_db[1]                 + "~n  " +    &
											                                                          wsf_msg_erro_db[2]  	  )
								
	                              Return false
                              End if
/* Lança observações */									
   int ws_qtd_linhas_obs
   int ws_seq_obs
   int ws_contador_A
   Long ws_chave_conta_cliente
  //
  ws_qtd_linhas_obs = UpperBound ( wsf_conta_cliente_obs )
  If ws_qtd_linhas_obs > 0 then
                       //                                 
                            select   Chave_conta_cliente
                               Into   :ws_chave_conta_cliente                           
                            From    PARK_Conta_cliente        
				      Where (   chave_contratos                   =    :wsf_chave_contrato                                      and
				                     CHave_cartao                      =    :wsf_chave_cartao                                         and
				                     COD_placa                          =    :wsf_cod_placa                                             and
				                     seq_contrato_cartao_placa   =    :ws_sequencia_lancamento                            and
				                     Chave_usuario                     =    :str_dados_Operador.stru_chave_operador       and
					                 Cod_lancamento                  =    :wsF_Cod_lancamento 	                             and
								    Dta_lancamento                   =    :ws_dta_lancamento                                     and
				                      Valor_lancamento                =     :wsF_Valor_lancamento                                and
				                      chave_caixa_lancamentos     =     :wsf_carimbo_lanc_caixa)
						Using SQLCA;

                              wsf_msg_erro_db[1]  =  "fs_rot_apur_efetiva_lancamto -rec_lanc max"
                              wsf_msg_erro_db[2]  =   SQLCA.SQLERRTEXT  
                              wsf_cod_erro_db       =   SQLCA.SQLCODE
						 
                              //
                              IF  wsf_cod_erro_db <> 0 then  
								goto desvio_erro	                         
                              End if

	 /* acha a sequencia de obs */
	    //
		 select max(Seq_obs)
		 into  :ws_seq_obs
		 From  PARK_Conta_Cliente_OBS
	     Where Chave_conta_cliente = :ws_chave_conta_cliente
		 Using SQLCA;
          //
           wsf_msg_erro_db[1]  =  ""
           wsf_msg_erro_db[2]  =   SQLCA.SQLERRTEXT  
           wsf_cod_erro_db       =   SQLCA.SQLCODE
           //
            IF  wsf_cod_erro_db = 0  or wsf_cod_erro_db = 100 then  
			    IF wsf_cod_erro_db = 100 then 	
				   ws_seq_obs = 0
				End if
				IF isnull(ws_seq_obs) then
					ws_seq_obs = 0
				End if
			    For ws_contador_A = 1 to ws_qtd_linhas_obs
				     IF len(trim(wsf_conta_cliente_obs[ws_contador_A])) > 0 then
					       ws_seq_obs ++
					        Insert into PARK_Conta_Cliente_OBS
					                       (Chave_conta_cliente,
							               Seq_obs,
							               Texto_OBS)
						       Values (:ws_chave_conta_cliente,
						                   :ws_seq_obs,
					                        :wsf_conta_cliente_obs[ws_contador_A])
					 		    Using SQLCA;
						  wsf_msg_erro_db[1]  =  "fs_rot_apur_efetiva_lancamto - CR01 Insert"
                                 wsf_msg_erro_db[2]  =   SQLCA.SQLERRTEXT  
                                 wsf_cod_erro_db       =   SQLCA.SQLCODE
						 
                              //
                              IF  wsf_cod_erro_db <> 0 then  
 			                         messagebox("Falha DB -  PARK_Conta_Cliente_OBS Insert ", "Não foi efetivado o lancamanto      ~n  " +    &
		                                                        wsf_msg_erro_db[1]   + "~n  " +    wsf_msg_erro_db[2]  	  )
                              End if
							  
					  End IF
			     NeXt	
				
	          End IF		
	              
     End if
	
desvio_erro:		
///////////////////////////////////////////////////////////////////////////////////////////////
  INSERT INTO PARK_Servicos_lavagem ( Chave_conta_cliente )
         SELECT servico_lavagem_aberto.Chave_conta_cliente
            FROM servico_lavagem_aberto 
            USing SQLCA;
////////////////////////////////////////////////////////////////////////////////////////////////										
Return true										
end function

on uo_park_apuracao_opcao.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uo_park_apuracao_opcao.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on
