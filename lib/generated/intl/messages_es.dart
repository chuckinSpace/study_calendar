// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a es locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'es';

  static m0(daysToTest) => "En ${daysToTest} días";

  static m1(numSessionsDeleted) => "test y ${numSessionsDeleted} sesiones fueron removidas de tu calendario";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "accessGoogle" : MessageLookupByLibrary.simpleMessage("ACCEDER CON GOOGLE"),
    "addTest" : MessageLookupByLibrary.simpleMessage("Nuevo Test"),
    "addTestTut" : MessageLookupByLibrary.simpleMessage("Crea un nuevo test, Será agregado al Calendario de tu dispositivo automáticamente junto con las sesiones de estudio correspondientes."),
    "addingSessions" : MessageLookupByLibrary.simpleMessage("Creando sesiones en tu dispositivo..."),
    "and" : MessageLookupByLibrary.simpleMessage("y"),
    "backLogin" : MessageLookupByLibrary.simpleMessage("VOLVER A ACCESO"),
    "calendarToUse" : MessageLookupByLibrary.simpleMessage("Calendario a utilizar"),
    "calendars" : MessageLookupByLibrary.simpleMessage("Calendarios"),
    "calendarsTut" : MessageLookupByLibrary.simpleMessage("Selecciona que calendario quieres sincronizar con la App. Study Planner analizara el tiempo que tienes disponible para crear sesiones y tests."),
    "cancel" : MessageLookupByLibrary.simpleMessage("Cancelar"),
    "courseCode" : MessageLookupByLibrary.simpleMessage("Codigo de la Asignatura"),
    "createAccount" : MessageLookupByLibrary.simpleMessage("CREAR CUENTA"),
    "cutOff" : MessageLookupByLibrary.simpleMessage("Descanso"),
    "cutOffTut" : MessageLookupByLibrary.simpleMessage("Estas horas son para descansar,usualmente para las horas de sueño.\nTip: Puedes usar el corte de Mañana para tomar en cuenta tus clases\nEjemplo: tus clases terminan a las 4pm, setea tu Corte de Mañana a las 4pm."),
    "delete" : MessageLookupByLibrary.simpleMessage("BORRAR"),
    "deleteConfirm" : MessageLookupByLibrary.simpleMessage("Esto borrará por completo éste test y todas las sesiones de estudio asociadas a él, quieres continuar?"),
    "deleteTest" : MessageLookupByLibrary.simpleMessage("Borrar test"),
    "description" : MessageLookupByLibrary.simpleMessage("Descripción"),
    "done" : MessageLookupByLibrary.simpleMessage("ENTENDIDO"),
    "dueDate" : MessageLookupByLibrary.simpleMessage("Dia del evento"),
    "dueInDays" : m0,
    "dueToday" : MessageLookupByLibrary.simpleMessage("Hoy!"),
    "dueTomorrow" : MessageLookupByLibrary.simpleMessage("Mañana!"),
    "emailEmpty" : MessageLookupByLibrary.simpleMessage(" Email No puede estar vacío"),
    "emailSent" : MessageLookupByLibrary.simpleMessage("Email enviado correctamente"),
    "end" : MessageLookupByLibrary.simpleMessage("FIN"),
    "endDateError" : MessageLookupByLibrary.simpleMessage("FIN debe ser despues que INICIO"),
    "enterDescription" : MessageLookupByLibrary.simpleMessage("Ingrese descripción"),
    "enterEmail" : MessageLookupByLibrary.simpleMessage("Ingresa un email"),
    "enterPassword" : MessageLookupByLibrary.simpleMessage("Ingresa una contraseña"),
    "enterSubject" : MessageLookupByLibrary.simpleMessage("Ingrese codigo de la Asignatura"),
    "forWord" : MessageLookupByLibrary.simpleMessage("para"),
    "forgot" : MessageLookupByLibrary.simpleMessage("Olvidaste tu contraseña?"),
    "goToCalendar" : MessageLookupByLibrary.simpleMessage("Abrir Calendario"),
    "goToCalendarTut" : MessageLookupByLibrary.simpleMessage("Esto abrirá el Calendario de tu aparato móvil, aquí podrás chequear las sesiones y test creados, tambien añadir recordatorios si asi lo deseas"),
    "goToTest" : MessageLookupByLibrary.simpleMessage("Ir Al Test"),
    "haveAccount" : MessageLookupByLibrary.simpleMessage("YA TENGO UNA CUENTA"),
    "logOut" : MessageLookupByLibrary.simpleMessage("Cerrar Sesión"),
    "login" : MessageLookupByLibrary.simpleMessage("Ingreso"),
    "moreSessionsCreated" : MessageLookupByLibrary.simpleMessage("nuevas sesiones de estudio fueron añadidas a tu calendario"),
    "morning" : MessageLookupByLibrary.simpleMessage("MAÑANA"),
    "night" : MessageLookupByLibrary.simpleMessage("NOCHE"),
    "nightOwl" : MessageLookupByLibrary.simpleMessage("Pajaro Nocturno"),
    "nightOwlTut" : MessageLookupByLibrary.simpleMessage("Si tu Punto Perfecto esta ocupado con otros eventos, Study Planner intentará colocar las sesiones de estudio mas tarde ese día cuando Pajaro Nocturno esta activo.\nDe lo contrario intentará mas temprano ese día."),
    "noTimeForSessions" : MessageLookupByLibrary.simpleMessage("No hay suficiente tiempo para hacer sesiones, se creó solo el Test"),
    "oneSessionCreated" : MessageLookupByLibrary.simpleMessage("Test y una nueva sesión de estudio fue añadida a tu Calendario"),
    "option" : MessageLookupByLibrary.simpleMessage("descripcion"),
    "passNoMatch" : MessageLookupByLibrary.simpleMessage("Contraseña no coincide"),
    "password" : MessageLookupByLibrary.simpleMessage("CONTRASEÑA"),
    "passwordEmpty" : MessageLookupByLibrary.simpleMessage("Contraseña no puede estar vacía"),
    "pastDue" : MessageLookupByLibrary.simpleMessage("En el pasado"),
    "pickADate" : MessageLookupByLibrary.simpleMessage(" Seleccione una Fecha"),
    "recover" : MessageLookupByLibrary.simpleMessage("Recupera tu Contraseña"),
    "recoverBig" : MessageLookupByLibrary.simpleMessage("RECUPERAR"),
    "repeatPass" : MessageLookupByLibrary.simpleMessage("REPITE LA CONTRASEÑA"),
    "selectACalendar" : MessageLookupByLibrary.simpleMessage("SELECCIONA UN CALENDARIO"),
    "session" : MessageLookupByLibrary.simpleMessage("Sesión"),
    "settings" : MessageLookupByLibrary.simpleMessage("Configuración"),
    "settingsTut" : MessageLookupByLibrary.simpleMessage("Usa las preferencias para definir que Calendario debemos usar para escribir y leer los eventos, selecciona tus horas ideales para estudiar, tiempos de descanso y más"),
    "settingsWarning" : MessageLookupByLibrary.simpleMessage("Antes de comenzar por favor selecciona cual es el Calendario que debemos usar"),
    "signUp" : MessageLookupByLibrary.simpleMessage("Registro"),
    "start" : MessageLookupByLibrary.simpleMessage("INICIO"),
    "studySession" : MessageLookupByLibrary.simpleMessage("Sesión de Estudio"),
    "sweetSpot" : MessageLookupByLibrary.simpleMessage("Punto Perfecto"),
    "sweetSpotTut" : MessageLookupByLibrary.simpleMessage("Study Planner siempre intentara colocar las sesiones de estudio entre estas horas primero."),
    "testAndOneSession" : MessageLookupByLibrary.simpleMessage("test y una sesion fueron removidos de tu calendario"),
    "testAndSessions" : m1,
    "testComplexity" : MessageLookupByLibrary.simpleMessage("Dificultad del test"),
    "testComplexityTut" : MessageLookupByLibrary.simpleMessage("Entre mas complejo es tu test, mayor cantidad de sesiones de estudio intentaremos colocar en tu calendario.\nEl número final de sesiones dependerá de cual es la fecha del test y de cuanto tiempo disponible encontremos en tu calendario\nEn el caso de que haya suficiente disponibilidad en tu calendario y suficientes dias hasta tu test el numero final de sesiones será el mismo que la dificultad que selecciones.\nEjemplo: Dificultad 10 / Numero de sesiones 10\nNota: El selector de dificultad solo será visible cuando la fecha del test sea mas de un día desde hoy\nEl numero máximo de sesiones es 30"),
    "testRemoved" : MessageLookupByLibrary.simpleMessage("test fue removido de tu calendario"),
    "tutorial" : MessageLookupByLibrary.simpleMessage("Mostrar Tutorial"),
    "whatIsThis" : MessageLookupByLibrary.simpleMessage("Que es esto?")
  };
}
