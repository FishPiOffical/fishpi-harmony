import defHttp, { IResponseData } from "../libs/http";

export const emojis: Record<string, string> = {
  "doge": "https://file.fishpi.cn/vditor/dist/images/emoji/doge.png",
  "trollface": "https://file.fishpi.cn/vditor/dist/images/emoji/trollface.png",
  "huaji": "https://file.fishpi.cn/vditor/dist/images/emoji/huaji.gif",
  "octocat": "https://file.fishpi.cn/vditor/dist/images/emoji/octocat.png",
  "wulian": "https://file.fishpi.cn/vditor/dist/images/emoji/wulian.png",
  "smile": `https://file.fishpi.cn/emoji/graphics/smile.png`,
  "laughing": `https://file.fishpi.cn/emoji/graphics/laughing.png`,
  "blush": `https://file.fishpi.cn/emoji/graphics/blush.png`,
  "smiley": `https://file.fishpi.cn/emoji/graphics/smiley.png`,
  "relaxed": `https://file.fishpi.cn/emoji/graphics/relaxed.png`,
  "smirk": `https://file.fishpi.cn/emoji/graphics/smirk.png`,
  "heart_eyes": `https://file.fishpi.cn/emoji/graphics/heart_eyes.png`,
  "kissing_heart": `https://file.fishpi.cn/emoji/graphics/kissing_heart.png`,
  "kissing_closed_eyes": `https://file.fishpi.cn/emoji/graphics/kissing_closed_eyes.png`,
  "flushed": `https://file.fishpi.cn/emoji/graphics/flushed.png`,
  "relieved": `https://file.fishpi.cn/emoji/graphics/relieved.png`,
  "satisfied": `https://file.fishpi.cn/emoji/graphics/satisfied.png`,
  "grin": `https://file.fishpi.cn/emoji/graphics/grin.png`,
  "wink": `https://file.fishpi.cn/emoji/graphics/wink.png`,
  "stuck_out_tongue_winking_eye": `https://file.fishpi.cn/emoji/graphics/stuck_out_tongue_winking_eye.png`,
  "stuck_out_tongue_closed_eyes": `https://file.fishpi.cn/emoji/graphics/stuck_out_tongue_closed_eyes.png`,
  "grinning": `https://file.fishpi.cn/emoji/graphics/grinning.png`,
  "kissing": `https://file.fishpi.cn/emoji/graphics/kissing.png`,
  "kissing_smiling_eyes": `https://file.fishpi.cn/emoji/graphics/kissing_smiling_eyes.png`,
  "stuck_out_tongue": `https://file.fishpi.cn/emoji/graphics/stuck_out_tongue.png`,
  "sleeping": `https://file.fishpi.cn/emoji/graphics/sleeping.png`,
  "worried": `https://file.fishpi.cn/emoji/graphics/worried.png`,
  "frowning": `https://file.fishpi.cn/emoji/graphics/frowning.png`,
  "anguished": `https://file.fishpi.cn/emoji/graphics/anguished.png`,
  "open_mouth": `https://file.fishpi.cn/emoji/graphics/open_mouth.png`,
  "grimacing": `https://file.fishpi.cn/emoji/graphics/grimacing.png`,
  "confused": `https://file.fishpi.cn/emoji/graphics/confused.png`,
  "hushed": `https://file.fishpi.cn/emoji/graphics/hushed.png`,
  "expressionless": `https://file.fishpi.cn/emoji/graphics/expressionless.png`,
  "unamused": `https://file.fishpi.cn/emoji/graphics/unamused.png`,
  "sweat_smile": `https://file.fishpi.cn/emoji/graphics/sweat_smile.png`,
  "sweat": `https://file.fishpi.cn/emoji/graphics/sweat.png`,
  "disappointed_relieved": `https://file.fishpi.cn/emoji/graphics/disappointed_relieved.png`,
  "weary": `https://file.fishpi.cn/emoji/graphics/weary.png`,
  "pensive": `https://file.fishpi.cn/emoji/graphics/pensive.png`,
  "disappointed": `https://file.fishpi.cn/emoji/graphics/disappointed.png`,
  "confounded": `https://file.fishpi.cn/emoji/graphics/confounded.png`,
  "fearful": `https://file.fishpi.cn/emoji/graphics/fearful.png`,
  "cold_sweat": `https://file.fishpi.cn/emoji/graphics/cold_sweat.png`,
  "persevere": `https://file.fishpi.cn/emoji/graphics/persevere.png`,
  "cry": `https://file.fishpi.cn/emoji/graphics/cry.png`,
  "sob": `https://file.fishpi.cn/emoji/graphics/sob.png`,
  "joy": `https://file.fishpi.cn/emoji/graphics/joy.png`,
  "astonished": `https://file.fishpi.cn/emoji/graphics/astonished.png`,
  "scream": `https://file.fishpi.cn/emoji/graphics/scream.png`,
  "tired_face": `https://file.fishpi.cn/emoji/graphics/tired_face.png`,
  "angry": `https://file.fishpi.cn/emoji/graphics/angry.png`,
  "rage": `https://file.fishpi.cn/emoji/graphics/rage.png`,
  "triumph": `https://file.fishpi.cn/emoji/graphics/triumph.png`,
  "sleepy": `https://file.fishpi.cn/emoji/graphics/sleepy.png`,
  "yum": `https://file.fishpi.cn/emoji/graphics/yum.png`,
  "mask": `https://file.fishpi.cn/emoji/graphics/mask.png`,
  "sunglasses": `https://file.fishpi.cn/emoji/graphics/sunglasses.png`,
  "dizzy_face": `https://file.fishpi.cn/emoji/graphics/dizzy_face.png`,
  "imp": `https://file.fishpi.cn/emoji/graphics/imp.png`,
  "smiling_imp": `https://file.fishpi.cn/emoji/graphics/smiling_imp.png`,
  "neutral_face": `https://file.fishpi.cn/emoji/graphics/neutral_face.png`,
  "no_mouth": `https://file.fishpi.cn/emoji/graphics/no_mouth.png`,
  "innocent": `https://file.fishpi.cn/emoji/graphics/innocent.png`,
  "alien": `https://file.fishpi.cn/emoji/graphics/alien.png`,
  "yellow_heart": `https://file.fishpi.cn/emoji/graphics/yellow_heart.png`,
  "blue_heart": `https://file.fishpi.cn/emoji/graphics/blue_heart.png`,
  "purple_heart": `https://file.fishpi.cn/emoji/graphics/purple_heart.png`,
  "heart": `https://file.fishpi.cn/emoji/graphics/heart.png`,
  "green_heart": `https://file.fishpi.cn/emoji/graphics/green_heart.png`,
  "broken_heart": `https://file.fishpi.cn/emoji/graphics/broken_heart.png`,
  "heartbeat": `https://file.fishpi.cn/emoji/graphics/heartbeat.png`,
  "heartpulse": `https://file.fishpi.cn/emoji/graphics/heartpulse.png`,
  "two_hearts": `https://file.fishpi.cn/emoji/graphics/two_hearts.png`,
  "revolving_hearts": `https://file.fishpi.cn/emoji/graphics/revolving_hearts.png`,
  "cupid": `https://file.fishpi.cn/emoji/graphics/cupid.png`,
  "sparkling_heart": `https://file.fishpi.cn/emoji/graphics/sparkling_heart.png`,
  "sparkles": `https://file.fishpi.cn/emoji/graphics/sparkles.png`,
  "star": `https://file.fishpi.cn/emoji/graphics/star.png`,
  "star2": `https://file.fishpi.cn/emoji/graphics/star2.png`,
  "dizzy": `https://file.fishpi.cn/emoji/graphics/dizzy.png`,
  "boom": `https://file.fishpi.cn/emoji/graphics/boom.png`,
  "collision": `https://file.fishpi.cn/emoji/graphics/collision.png`,
  "anger": `https://file.fishpi.cn/emoji/graphics/anger.png`,
  "exclamation": `https://file.fishpi.cn/emoji/graphics/exclamation.png`,
  "question": `https://file.fishpi.cn/emoji/graphics/question.png`,
  "grey_exclamation": `https://file.fishpi.cn/emoji/graphics/grey_exclamation.png`,
  "grey_question": `https://file.fishpi.cn/emoji/graphics/grey_question.png`,
  "zzz": `https://file.fishpi.cn/emoji/graphics/zzz.png`,
  "dash": `https://file.fishpi.cn/emoji/graphics/dash.png`,
  "sweat_drops": `https://file.fishpi.cn/emoji/graphics/sweat_drops.png`,
  "notes": `https://file.fishpi.cn/emoji/graphics/notes.png`,
  "musical_note": `https://file.fishpi.cn/emoji/graphics/musical_note.png`,
  "fire": `https://file.fishpi.cn/emoji/graphics/fire.png`,
  "poop": `https://file.fishpi.cn/emoji/graphics/poop.png`,
  "+1": `https://file.fishpi.cn/emoji/graphics/%2B1.png`,
  "thumbsup": `https://file.fishpi.cn/emoji/graphics/thumbsup.png`,
  "-1": `https://file.fishpi.cn/emoji/graphics/-1.png`,
  "thumbsdown": `https://file.fishpi.cn/emoji/graphics/thumbsdown.png`,
  "ok_hand": `https://file.fishpi.cn/emoji/graphics/ok_hand.png`,
  "punch": `https://file.fishpi.cn/emoji/graphics/punch.png`,
  "facepunch": `https://file.fishpi.cn/emoji/graphics/facepunch.png`,
  "fist": `https://file.fishpi.cn/emoji/graphics/fist.png`,
  "v": `https://file.fishpi.cn/emoji/graphics/v.png`,
  "wave": `https://file.fishpi.cn/emoji/graphics/wave.png`,
  "hand": `https://file.fishpi.cn/emoji/graphics/hand.png`,
  "raised_hand": `https://file.fishpi.cn/emoji/graphics/raised_hand.png`,
  "open_hands": `https://file.fishpi.cn/emoji/graphics/open_hands.png`,
  "point_up": `https://file.fishpi.cn/emoji/graphics/point_up.png`,
  "point_down": `https://file.fishpi.cn/emoji/graphics/point_down.png`,
  "point_left": `https://file.fishpi.cn/emoji/graphics/point_left.png`,
  "point_right": `https://file.fishpi.cn/emoji/graphics/point_right.png`,
  "raised_hands": `https://file.fishpi.cn/emoji/graphics/raised_hands.png`,
  "pray": `https://file.fishpi.cn/emoji/graphics/pray.png`,
  "point_up_2": `https://file.fishpi.cn/emoji/graphics/point_up_2.png`,
  "clap": `https://file.fishpi.cn/emoji/graphics/clap.png`,
  "muscle": `https://file.fishpi.cn/emoji/graphics/muscle.png`,
  "couple": `https://file.fishpi.cn/emoji/graphics/couple.png`,
  "family": `https://file.fishpi.cn/emoji/graphics/family.png`,
  "two_men_holding_hands": `https://file.fishpi.cn/emoji/graphics/two_men_holding_hands.png`,
  "two_women_holding_hands": `https://file.fishpi.cn/emoji/graphics/two_women_holding_hands.png`,
  "dancer": `https://file.fishpi.cn/emoji/graphics/dancer.png`,
  "dancers": `https://file.fishpi.cn/emoji/graphics/dancers.png`,
  "ok_woman": `https://file.fishpi.cn/emoji/graphics/ok_woman.png`,
  "no_good": `https://file.fishpi.cn/emoji/graphics/no_good.png`,
  "information_desk_person": `https://file.fishpi.cn/emoji/graphics/information_desk_person.png`,
  "raising_hand": `https://file.fishpi.cn/emoji/graphics/raising_hand.png`,
  "bride_with_veil": `https://file.fishpi.cn/emoji/graphics/bride_with_veil.png`,
  "person_with_pouting_face": `https://file.fishpi.cn/emoji/graphics/person_with_pouting_face.png`,
  "person_frowning": `https://file.fishpi.cn/emoji/graphics/person_frowning.png`,
  "bow": `https://file.fishpi.cn/emoji/graphics/bow.png`,
  "couplekiss": `https://file.fishpi.cn/emoji/graphics/couplekiss.png`,
  "couple_with_heart": `https://file.fishpi.cn/emoji/graphics/couple_with_heart.png`,
  "massage": `https://file.fishpi.cn/emoji/graphics/massage.png`,
  "haircut": `https://file.fishpi.cn/emoji/graphics/haircut.png`,
  "nail_care": `https://file.fishpi.cn/emoji/graphics/nail_care.png`,
  "boy": `https://file.fishpi.cn/emoji/graphics/boy.png`,
  "girl": `https://file.fishpi.cn/emoji/graphics/girl.png`,
  "woman": `https://file.fishpi.cn/emoji/graphics/woman.png`,
  "man": `https://file.fishpi.cn/emoji/graphics/man.png`,
  "baby": `https://file.fishpi.cn/emoji/graphics/baby.png`,
  "older_woman": `https://file.fishpi.cn/emoji/graphics/older_woman.png`,
  "older_man": `https://file.fishpi.cn/emoji/graphics/older_man.png`,
  "person_with_blond_hair": `https://file.fishpi.cn/emoji/graphics/person_with_blond_hair.png`,
  "man_with_gua_pi_mao": `https://file.fishpi.cn/emoji/graphics/man_with_gua_pi_mao.png`,
  "man_with_turban": `https://file.fishpi.cn/emoji/graphics/man_with_turban.png`,
  "construction_worker": `https://file.fishpi.cn/emoji/graphics/construction_worker.png`,
  "cop": `https://file.fishpi.cn/emoji/graphics/cop.png`,
  "angel": `https://file.fishpi.cn/emoji/graphics/angel.png`,
  "princess": `https://file.fishpi.cn/emoji/graphics/princess.png`,
  "smiley_cat": `https://file.fishpi.cn/emoji/graphics/smiley_cat.png`,
  "smile_cat": `https://file.fishpi.cn/emoji/graphics/smile_cat.png`,
  "heart_eyes_cat": `https://file.fishpi.cn/emoji/graphics/heart_eyes_cat.png`,
  "kissing_cat": `https://file.fishpi.cn/emoji/graphics/kissing_cat.png`,
  "smirk_cat": `https://file.fishpi.cn/emoji/graphics/smirk_cat.png`,
  "scream_cat": `https://file.fishpi.cn/emoji/graphics/scream_cat.png`,
  "crying_cat_face": `https://file.fishpi.cn/emoji/graphics/crying_cat_face.png`,
  "joy_cat": `https://file.fishpi.cn/emoji/graphics/joy_cat.png`,
  "pouting_cat": `https://file.fishpi.cn/emoji/graphics/pouting_cat.png`,
  "japanese_ogre": `https://file.fishpi.cn/emoji/graphics/japanese_ogre.png`,
  "japanese_goblin": `https://file.fishpi.cn/emoji/graphics/japanese_goblin.png`,
  "see_no_evil": `https://file.fishpi.cn/emoji/graphics/see_no_evil.png`,
  "hear_no_evil": `https://file.fishpi.cn/emoji/graphics/hear_no_evil.png`,
  "speak_no_evil": `https://file.fishpi.cn/emoji/graphics/speak_no_evil.png`,
  "guardsman": `https://file.fishpi.cn/emoji/graphics/guardsman.png`,
  "skull": `https://file.fishpi.cn/emoji/graphics/skull.png`,
  "feet": `https://file.fishpi.cn/emoji/graphics/feet.png`,
  "lips": `https://file.fishpi.cn/emoji/graphics/lips.png`,
  "kiss": `https://file.fishpi.cn/emoji/graphics/kiss.png`,
  "droplet": `https://file.fishpi.cn/emoji/graphics/droplet.png`,
  "ear": `https://file.fishpi.cn/emoji/graphics/ear.png`,
  "eyes": `https://file.fishpi.cn/emoji/graphics/eyes.png`,
  "nose": `https://file.fishpi.cn/emoji/graphics/nose.png`,
  "tongue": `https://file.fishpi.cn/emoji/graphics/tongue.png`,
  "love_letter": `https://file.fishpi.cn/emoji/graphics/love_letter.png`,
  "bust_in_silhouette": `https://file.fishpi.cn/emoji/graphics/bust_in_silhouette.png`,
  "busts_in_silhouette": `https://file.fishpi.cn/emoji/graphics/busts_in_silhouette.png`,
  "speech_balloon": `https://file.fishpi.cn/emoji/graphics/speech_balloon.png`,
  "thought_balloon": `https://file.fishpi.cn/emoji/graphics/thought_balloon.png`
};

export class Emoji {
  private token: string = '';

  constructor(token?: string) {
    if (!token) return;
    this.setToken(token);
  }

  setToken(token: string) {
    this.token = token;
  }

  list() {
    return defHttp.post<string>('/api/cloud/get', {
      data: {
        gameId: 'emojis',
        apiKey: this.token,
      }
    }).then(res => JSON.parse(res) as string[]).catch(() => [] as string[]);
  }

  save(data: string[]) {
    return defHttp.post<IResponseData>('/api/cloud/sync', {
      data: {
        gameId: 'emojis',
        apiKey: this.token,
        data: JSON.stringify(data)
      }
    }).then(() => true).catch(() => false);
  }

  append(data: string) {
    return this.list().then(async (list: string[]) => {
      if (list.includes(data)) return true;
      list.push(data);
      return await this.save(list);
    });
  }

  remove(data: string) {
    return this.list().then(async (list: string[]) => {
      if (!list.includes(data)) return true;
      list.splice(list.indexOf(data), 1);
      return await this.save(list);
    });
  }

  exists(data: string) {
    return this.list().then((list: string[]) => list.includes(data));
  }

  static get default() {
    return emojis;
  }
}