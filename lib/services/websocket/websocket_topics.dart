class WebSocketTopics {
  static String clinicTopic(String clinicId) =>
      '/topic/clinic/clinic_$clinicId';

  static String userTopic(String userId) => '/topic/user/$userId';

  static const String sendChatMessage = '/app/chat.send';

  static const String testNotification = '/app/notify';
  
}
