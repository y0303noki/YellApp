import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yell_app/components/widget/common_widget.dart';
import 'package:yell_app/components/widget/text_widget.dart';
import 'package:yell_app/firebase/invite_firebase.dart';
import 'package:yell_app/model/invite.dart';
import 'package:yell_app/state/invite_provider.dart';
import 'package:flutter/services.dart';

InviteFirebase inviteFirebase = InviteFirebase();

/// 招待ページ
class InviteMainPage extends ConsumerWidget {
  const InviteMainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invite = ref.watch(inviteProvider);
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 29, 35, 37),
      ),
      body: Container(
        margin: const EdgeInsets.only(
          top: 10,
          left: 10,
          right: 10,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                TextWidget.headLineText5('おともだちを招待して'),
                TextWidget.headLineText5('応援してもらいましょう'),
              ],
            ),
            Column(
              children: [
                _inviteCodeWidget(invite),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        IconButton(
                          iconSize: 80,
                          icon: CircleAvatar(
                            backgroundColor: Colors.grey[400],
                            radius: 40,
                            child: const Icon(
                              Icons.copy,
                              size: 40,
                            ),
                          ),
                          onPressed: () async {
                            // クリップボードにコピー
                            final data = ClipboardData(text: invite.code);
                            await Clipboard.setData(data);
                          },
                        ),
                        const Text('コピー'),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          iconSize: 80,
                          icon: CircleAvatar(
                            backgroundColor: Colors.grey[400],
                            radius: 40,
                            child: const Icon(
                              Icons.refresh,
                              size: 40,
                            ),
                          ),
                          onPressed: () async {
                            _updateInviteCode(invite);
                            // // 更新
                            // InviteModel? _inviteModel = await inviteFirebase
                            //     .updateInviteCode(invite.id);

                            // if (_inviteModel == null) {
                            //   // ありえない
                            //   return;
                            // }
                            // // stateにセット
                            // invite.id = _inviteModel.id;
                            // invite.setExpiredAt(
                            //     _inviteModel.code, _inviteModel.expiredAt);
                          },
                        ),
                        const Text('更新'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            CommonWidget.descriptionWidget(CommonWidget.lightbulbIcon(),
                'トップページの「応援する」から招待コードを入力してもらいます。'),
          ],
        ),
      ),
    );
  }

  // 招待コード更新
  void _updateInviteCode(Invite invite) async {
    // 更新
    InviteModel? _inviteModel =
        await inviteFirebase.updateInviteCode(invite.id);

    if (_inviteModel == null) {
      // ありえない
      return;
    }
    // stateにセット
    invite.id = _inviteModel.id;
    invite.setExpiredAt(_inviteModel.code, _inviteModel.expiredAt);
  }

  Widget _inviteCodeWidget(Invite invite) {
    return FutureBuilder(
      future: inviteFirebase.fetchOwnInviteFirst(invite.id),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        // 通信中
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.error != null) {
          // エラー
          return const Center(
            child: Text('エラーがおきました'),
          );
        }

        // 成功処理
        if (snapshot.connectionState == ConnectionState.done) {
          DateTime now = DateTime.now();
          InviteModel? _data = snapshot.data;

          if (_data == null) {
            // 未発行 アリエないけど念のため
            return Container();
          }

          // stateにセット
          invite.id = _data.id;
          invite.code = _data.code;
          invite.expiredAt = _data.expiredAt;

          if (_data.isDeleted || _data.expiredAt == null) {
            // 無効な招待コード
            return const Text('無効です');
          } else if (now.isAfter(_data.expiredAt as DateTime)) {
            // 有効期限切れ
            return const Text('有効期限切れです');
          } else {
            // その他は有効な招待コードがある
            invite.code = _data.code;
            return Container(
              child: Column(
                children: [
                  const Text('招待コード'),
                  TextField(
                    textAlign: TextAlign.center,
                    enabled: false,
                    controller: TextEditingController(text: invite.code),
                    style: const TextStyle(
                      fontSize: 30,
                    ),
                    maxLines: 1,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color(0xFFDBEDFF),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text('有効期限'),
                      Text(invite.expiredAtStr),
                    ],
                  ),
                ],
              ),
            );
          }
        }
        return const Text('無効です');
      },
    );
  }
}
