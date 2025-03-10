﻿#Область ОбработчикиСобытий

&НаКлиенте
Процедура ДженерикПриИзменении(Элемент) 
	
	УстановитьДоступностьФункционалаПодбора();
	
КонецПроцедуры

&НаКлиенте
Процедура АналогПриИзменении(Элемент) 
	
	УстановитьДоступностьФункционалаПодбора(); 
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)   
	
	УстановитьДоступностьФункционалаПодбора();    
	//ТекущийПользователь = ПользователиИнформационнойБазы.ТекущийПользователь();
	
	
КонецПроцедуры

&НаКлиенте
Процедура ПрепаратОчистка(Элемент, СтандартнаяОбработка)
	
	Объект.Препарат = ПредопределенноеЗначение("Справочник.Препараты.ПустаяСсылка");
	УстановитьДоступностьФункционалаПодбора(); 
	
КонецПроцедуры

&НаКлиенте
Процедура ПрепаратПриИзменении(Элемент)
	
	УстановитьДоступностьФункционалаПодбора();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПрепаратовПриИзменении(Элемент)   
	
	ЭтаФорма.Элементы.Печать.Шрифт = Новый Шрифт;
	Если Объект.СписокПрепаратов.Количество() > 0 Тогда    
		ЭтаФорма.Элементы.Печать.Шрифт = Новый Шрифт(,,Истина);
	КонецЕсли; 
	
КонецПроцедуры


#КонецОбласти  

#Область Команды 

 &НаКлиенте
 Процедура Поиск(Команда) 
	 
	ПрепаратЭталон = Объект.Препарат;
	Если Объект.СписокПрепаратов.Количество() > 0 Тогда
		Объект.СписокПрепаратов.Очистить();
	КонецЕсли;
	
	Если НепустоеДействующееВещество(ПрепаратЭталон) Тогда
		ВыполнитьПоискЛС(ПрепаратЭталон);
	Иначе 
		ПоказатьПредупреждение(, "У препарата не указано действующее вещество.");
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция НепустоеДействующееВещество(Препарат)

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Препараты.ДействующееВещество КАК ДействующееВещество
	               |ИЗ
	               |	Справочник.Препараты КАК Препараты
	               |ГДЕ
	               |	Препараты.Ссылка = &Ссылка";
	Запрос.УстановитьПараметр("Ссылка", Препарат);
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Возврат ЗначениеЗаполнено(Выборка.ДействующееВещество);
	
КонецФункции	

 &НаКлиенте
Процедура ОчиститьВыбор(Команда)  
	
	Объект.СписокПрепаратов.Очистить();
	Объект.Препарат = ПредопределенноеЗначение("Справочник.Препараты.ПустаяСсылка");
	Аналог = Ложь;
	Дженерик = Ложь;
	УстановитьДоступностьФункционалаПодбора();
	
КонецПроцедуры

&НаКлиенте
Процедура Печать(Команда)
	ТабДок = ПечатьНаСервере(); 
	ТабДок.Показать();
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура УстановитьВидимостьКолонок(Реквизит, СтруктураКолонок) 
	
	УсловноеОформление.Элементы.Очистить();
	Если Реквизит <> Неопределено Тогда
		
		ЭлементОформления = УсловноеОформление.Элементы.Добавить(); 
		ЭлементОформления.Оформление.УстановитьЗначениеПараметра("Видимость", ЛОЖЬ);  
		
		ЭлементОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(Реквизит); 
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.ПравоеЗначение = ЛОЖЬ; 
		
		Для каждого Элемент из СтруктураКолонок Цикл
			ПолеОформления = ЭлементОформления.Поля.Элементы.Добавить();
			ПолеОформления.Поле = Новый ПолеКомпоновкиДанных(Элемент.Значение); 
			ПолеОформления.Использование = Истина;	
		КонецЦикла;
		
	Иначе
		
		ЭлементОформления = УсловноеОформление.Элементы.Добавить(); 
		ЭлементОформления.Оформление.УстановитьЗначениеПараметра("Видимость", ИСТИНА);     
		
		///////to do////////	
		ЭлементОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Аналог"); 
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.ПравоеЗначение = ИСТИНА; 
		///////////////	
		
		Для каждого Элемент из СтруктураКолонок Цикл
			ПолеОформления = ЭлементОформления.Поля.Элементы.Добавить();
			ПолеОформления.Поле = Новый ПолеКомпоновкиДанных(Элемент.Значение); 
			ПолеОформления.Использование = Истина;	
		КонецЦикла;  
		
	КонецЕсли;
	
КонецПроцедуры	

&НаКлиенте
Процедура УстановитьДоступностьФункционалаПодбора()
	
	УстановитьДоступностьПодбора = ЗначениеЗаполнено(Объект.Препарат) И (Дженерик = Истина ИЛИ Аналог = Истина);
	ЭтаФорма.Элементы.ФормаПоиск.Доступность = УстановитьДоступностьПодбора;
	ЭтаФорма.Элементы.СписокПрепаратов.Видимость = УстановитьДоступностьПодбора;
	ЭтаФорма.Элементы.Печать.Доступность = УстановитьДоступностьПодбора;
	ЭтаФорма.Элементы.Составитель.Доступность = УстановитьДоступностьПодбора;
	
	Если УстановитьДоступностьПодбора Тогда
		
		ОграничивающийРеквизит = Неопределено;
		СтруктураКолонок = 
		Новый Структура("КолонкаАналог, КолонкаПриоритет, КолонкаДженерик", "СписокПрепаратовАналог", "СписокПрепаратовПриоритет", "СписокПрепаратовДженерик"); 
		
		Если НЕ Аналог Тогда
			ОграничивающийРеквизит = "Аналог";
			СтруктураКолонок.Удалить("КолонкаДженерик");
		ИначеЕсли НЕ Дженерик Тогда
			ОграничивающийРеквизит = "Дженерик";
			СтруктураКолонок.Удалить("КолонкаАналог");
			СтруктураКолонок.Удалить("КолонкаПриоритет");
		КонецЕсли; 
		
		УстановитьВидимостьКолонок(ОграничивающийРеквизит, СтруктураКолонок);
		
	КонецЕсли;
	
КонецПроцедуры	

&НаСервере
Процедура ВыполнитьПоискЛС(Препарат)
	
	//Реализовано пока что через поиск по справочникам, так как аналоги в силу своей идентификации добавляются отдельно.
	ЗапросДляДженериков = Новый Запрос;
	ЗапросДляДженериков.Текст = "ВЫБРАТЬ
	|	Препараты.ДействующееВещество КАК ДействующееВещество
	|ПОМЕСТИТЬ ВТ_ДействующееВещество
	|ИЗ
	|	Справочник.Препараты КАК Препараты
	|ГДЕ
	|	Препараты.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Препараты.Ссылка КАК Препарат,
	|	ИСТИНА КАК Дженерик
	|ИЗ
	|	Справочник.Препараты КАК Препараты
	|ГДЕ
	|	Препараты.ДействующееВещество В
	|			(ВЫБРАТЬ
	|				ВТ_ДействующееВещество.ДействующееВещество КАК ДействующееВещество
	|			ИЗ
	|				ВТ_ДействующееВещество КАК ВТ_ДействующееВещество)";
	ЗапросДляДженериков.УстановитьПараметр("Ссылка", Препарат);
	Выборка = ЗапросДляДженериков.Выполнить().Выбрать(); 
	
	Пока Выборка.Следующий() Цикл 
		НоваяСтрока = Объект.СписокПрепаратов.Добавить();	
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);	
	КонецЦикла;	
	
КонецПроцедуры	  

&НаСервере
Функция ПечатьНаСервере()
	
	Структура = Новый Структура;
	Структура.Вставить("Аналог", Аналог);
	Структура.Вставить("Дженерик", Дженерик);
	Структура.Вставить("ТекущийПользователь", Составитель);
	Результат = РеквизитФормыВЗначение("Объект").СоздатьПечатнуюФорму(Структура);
	
	Возврат Результат;
	
КонецФункции





